::  %aloe, message transceiver
::
::    Implements the Ames network protocol for messaging among ships.
::
!:
!?  141
::  3-bit ames protocol version; only packets at this version will be accepted
::
=/  protocol-version=?(%0 %1 %2 %3 %4 %5 %6 %7)  %0
=>
::  type definitions
::
|%
::  |able: public move interfaces
::
++  able
  |%
  ::  +task: requests to this vane
  ::
  +$  task
    $%  ::  %pass-message: encode and send :message to another :ship
        ::
        [%pass-message =ship =path payload=*]
        ::  %forward-message: ask :ship to relay :message to another ship
        ::
        ::    This sends :ship a message that has been wrapped in an envelope
        ::    containing the address of the intended recipient.
        ::
        [%forward-message =ship =path payload=*]
        ::  %hear: receive a packet from unix
        ::
        [%hear =lane =raw-packet-blob]
        ::  %hole: receive notification from unix that packet crashed
        ::
        [%hole =lane =raw-packet-blob]
        ::  %born: urbit process restarted
        ::
        [%born ~]
        ::  %crud: previous unix event errored
        ::
        [%crud =error]
        ::  %vega: kernel reset notification
        ::
        [%vega ~]
        ::  %wegh: request for memory usage report
        ::
        [%wegh ~]
    ==
  ::  +gift: responses from this vane
  ::
  +$  gift
    $%  ::  %ack-message: ack for a command, sent to a client vane
        ::
        ::    Flows we initiate are called "forward flows." In a forward flow,
        ::    a client vane can ask us to send a command to our neighbor.
        ::    When we get a message from the neighbor acking our command,
        ::    we notify the client vane by sending it this gift.
        ::
        [%ack-message =error=(unit error)]
        ::  %give-message: relay response message to another vane
        ::
        ::    Emitted upon hearing a message from Unix (originally from
        ::    another ship) in response to a message the vane
        ::    asked us to send.
        ::
        [%give-message payload=*]
        ::  %send: tell unix to send a packet to another ship
        ::
        ::    Each %mess +task will cause one or more %send gifts to be
        ::    emitted to Unix, one per message fragment.
        ::
        [%send =lane =raw-packet-blob]
        ::  %turf: tell unix which domains to bind
        ::
        ::    Sometimes Jael learns new domains we should be using
        ::    to look up galaxies. We hand this information to Unix.
        ::
        [%turf domains=(list domain)]
        ::  %mass: memory usage report, in response to a %wegh +task
        ::
        [%mass =mass]
    ==
  --
::  +move: output effect
::
+$  move  [=duct card=(wind note gift:able)]
::  +note: request from us to another vane
::
+$  note
  $%  $:  %b
          $%  ::  %wait: set a timer at :date
              ::
              [%wait date=@da]
              ::  %rest: cancel a timer at :date
              ::
              [%rest date=@da]
      ==  ==
      $:  %c
          $%  ::  %pass-message: encode and send :payload to :ship
              ::
              [%pass-message =ship =path payload=*]
      ==  ==
      $:  %d
          $%  [%flog =flog:dill]
      ==  ==
      $:  %g
          $%  ::  %pass-message: encode and send :payload to :ship
              ::
              [%pass-message =ship =path payload=*]
      ==  ==
      $:  %j
          $%  ::  %pass-message: encode and send :payload to :ship
              ::
              [%pass-message =ship =path payload=*]
              ::  %meet: tell jael we've neighbored with :ship at :life
              ::
              [%meet =ship =life]
              ::  %pubs: subscribe to public keys for :ship
              ::
              [%pubs =ship]
              ::  %turf: subscribe to domains to look up galaxies
              ::
              ::    We'll relay this information out to Unix when we receive
              ::    an update from Jael.
              ::
              [%turf ~]
              ::  %vein: subscribe to our private keys
              ::
              [%vein ~]
  ==  ==  ==
::  +sign: response to us from another vane
::
+$  sign
  $%  $:  %b
          $%  ::  %wake: a timer we set has elapsed
              ::
              [%wake ~]
      ==  ==
      $:  %c
          $%  ::  %give-message: response (subscription update) from clay
              ::
              ::    Only applicable for backward flows, where the neighbor
              ::    initiated the flow and we're streaming down subscription
              ::    data.
              ::
              [%give-message payload=*]
              ::  %ack-message: acknowledge a request (forward message)
              ::
              ::    If :error is non-null, this is a nack (negative
              ::    acknowledgment). An Ames client must acknowledge a request,
              ::    whereas a subscription update has no application-level
              ::    ack; just a message ack from Ames.
              ::
              [%ack-message =error=(unit error)]
      ==  ==
      $:  %g
          $%  ::  %give-message: response (subscription update) from a gall app
              ::
              ::    Only applicable for backward flows, where the neighbor
              ::    initiated the flow and we're streaming down subscription
              ::    data.
              ::
              [%give-message payload=*]
              ::  %ack-message: acknowledge a request (forward message)
              ::
              ::    If :error is non-null, this is a nack (negative
              ::    acknowledgment). An Ames client must acknowledge a request,
              ::    whereas a subscription update has no application-level
              ::    ack; just a message ack from Ames.
              ::
              [%ack-message =error=(unit error)]
      ==  ==
      $:  %j
          $%  ::  %give-message: response (subscription update) from jael
              ::
              ::    Only applicable for backward flows, where the neighbor
              ::    initiated the flow and we're streaming down subscription
              ::    data.
              ::
              [%give-message payload=*]
              ::  %ack-message: acknowledge a request (forward message)
              ::
              ::    If :error is non-null, this is a nack (negative
              ::    acknowledgment). An Ames client must acknowledge a request,
              ::    whereas a subscription update has no application-level
              ::    ack; just a message ack from Ames.
              ::
              [%ack-message =error=(unit error)]
              ::  %pubs: a ship's public keys changed
              ::
              [%pubs public:able:jael]
              ::  %sunk: a ship breached (reincarnated)
              ::
              [%sunk =ship =life]
              ::  %turf: receive new list of galaxy domains
              ::
              ::    We'll relay this information out to Unix.
              ::
              [%turf domains=(list domain)]
              ::  %vein: our private keys changed
              ::
              [%vein =life vein=(map life ring)]
  ==  ==  ==
::  +ames-state: all persistent state
::
+$  ames-state
  $:  =life
      crypto-core=acru:ames
      $=  peers
      %+  map  ship
      $%  [%pending-pki =blocked-actions]
          [%peer =peer-state]
      ==
  ==
+$  peer-state
  $:  =pki-info
      lane=(unit lane)
      =bone-manager
      inbound=(map bone inbound-state)
      outbound=(map bone outbound-state)
  ==
+$  bone-manager
  $:  next=bone
      by-duct=(map duct bone)
      by-bone=(map bone duct)
  ==
+$  blocked-actions
  $:  inbound-packets=(list [=lane =raw-packet-blob])
      outbound-messages=(list [=duct route=path payload=*])
  ==
+$  inbound-state
  $:  last-acked=message-seq
      partial-messages=(map message-seq partial-message)
      awaiting-application=(unit [=message-seq =raw-packet-hash =lane])
      nacks=(map message-seq error)
  ==
+$  partial-message
  $:  =encoding
      num-received=fragment-num
      next-fragment=fragment-num
      fragments=(map fragment-num partial-message-blob)
  ==
::  +outbound-state: all data relevant to sending messages to a peer
::
::    TODO docs when I actually understand this
::    next-tick: next tick to fill
::    till-tick: earliest unfinished message
::
+$  outbound-state
  $:  next-tick=message-seq
      till-tick=message-seq
      live-messages=(map message-seq live-message)
      =pump-state
  ==
::  +live-message: state of a partially sent message
::
::    :error is a double unit:
::      ~           ::  we don't know whether the message succeeded or failed
::      [~ ~]       ::  we know the message succeeded
::      [~ ~ error] ::  we know the message failed
::
+$  live-message
  $:  error=(unit (unit error))
      remote-route=path
      total-fragments=fragment-num
      acked-fragments=fragment-num
      unsent-packets=(list raw-packet-descriptor)
  ==
::  +pump-state: all data relevant to a per-ship |packet-pump
::
::    Note that while :live and :lost are structurally normal queues,
::    we actually treat them as bespoke priority queues.
::
+$  pump-state
  $:  live=(qeu live-raw-packet)
      lost=(qeu raw-packet-descriptor)
      metrics=pump-metrics
  ==
::  +live-raw-packet: data needed to track a raw packet in flight
::
::    Prepends :expiration-date and :sent-date to a +raw-packet-descriptor.
::
+$  live-raw-packet
  %-  expiring
  $:  sent-date=@da
      =raw-packet-descriptor
  ==
::  +raw-packet-descriptor: immutable data for a possibly sent raw packet
::
::    TODO: what is the virgin field?
::
+$  raw-packet-descriptor
  $:  virgin=?
      =fragment-index
      =raw-packet-hash
      =raw-packet-blob
  ==
::  +pump-metrics: congestion control information
::
::    TODO: document
::
+$  pump-metrics
  $:  $:  window-length=@ud
          max-packets-out=@ud
          retry-length=@ud
      ==
      $:  rtt=@dr
          last-sent=@da
          last-deadline=@da
  ==  ==
::
::  ames.c => raw-packet-blob
::  raw-packet-blob=@ -> `raw-packet`[header packet-blob=@]
::  packet-blob=@ -> `packet`[fragment-index partial-message-blob=@]
::  (cat 13 partial-message-blob ...) = message-blob
::  message-blob=@ -> `message`[%bond !! payload=*]
::  payload => other vane
::
::  XX move crypto to packet-blob -> packet decoder
::
+$  packets  (lest packet)
+$  packet
    $:  =message-descriptor
        =fragment-num
        =partial-message-blob
    ==
::
+$  message
  $%  [%back !!]
      [%bond !!]
      [%fore !!]
  ==
::  +meal: packet payload
::
+$  meal
  $%  ::  %back: acknowledgment
      ::
      ::    bone: opaque flow identifier
      ::    packet-hash: hash of acknowledged contents
      ::    error: non-null iff nack (negative acknowledgment)
      ::    lag: computation time, for use in congestion control
      ::
      [%back =bone =raw-packet-hash error=(unit error) lag=@dr]
      ::  %bond: full message
      ::
      ::    message-id: pair of flow id and message sequence number
      ::    remote-route: intended recipient module on receiving ship
      ::    payload: noun payload
      ::
      [%bond =message-id remote-route=path payload=*]
      ::  %carp: message fragment
      ::
      ::    message-descriptor: message id and fragment count
      ::    fragment-num: which fragment is being sent
      ::    partial-message-blob: one slice of a message's bytestream
      ::
      [%carp =message-descriptor =fragment-num =partial-message-blob]
      ::  %fore: forwarded packet
      ::
      ::    ship: destination ship, to be forwarded to
      ::    lane: IP route, or null if unknown
      ::    payload: the wrapped packet, to be sent to :ship
      ::
      [%fore =ship lane=(unit lane) raw-packet-blob=@]
  ==
::  +pki-context: context for messaging between :our and peer
::
+$  pki-context  [our=ship =our=life crypto-core=acru:ames her=ship =pki-info]
::  +pki-info: (possibly) secure channel between our and her
::
::    Everything we need to encode or decode a message between our and her.
::    :her-sponsors is the list of her current sponsors, not numeric ancestors.
::
::    TODO: do we need the map of her public keys, or just her current key?
::
+$  pki-info
  $:  fast-key=(unit [=key-hash key=(expiring =symmetric-key)])
      =her=life
      her-public-keys=(map life public-key)
      her-sponsors=(list ship)
  ==
::  +deed: identity attestation, typically signed by sponsor
::
+$  deed  (attested [=life =public-key =signature])
::
::  XX names
::
++  packet-format
  |%
  +$  none  raw-payload=@
  +$  open  [=from=life deed=(unit deed) signed-payload=@]
  +$  fast  [=key-hash encrypted-payload=@]
  +$  full  [[=to=life =from=life] deed=(unit deed) encrypted-payload=@]
  --
::  +domain: an HTTP domain, as list of '.'-delimited segments
::
+$  domain  (list @t)
::  +lane: route; ip addresss, port, and expiration date
::
::    A lane can expire when we're no longer confident the other party
::    is still reachable using this route.
::
::    TODO: more docs
::
+$  lane
  $%  [%if (expiring [port=@ud ipv4=@if])]
      [%is port=@ud lane=(unit lane) ipv6=@is]
      [%ix (expiring [port=@ud ipv4=@if])]
  ==
::
::  Aspirational
::
+$  lois                  [direct=? lane=*]
+$  symmetric-key         @uvI
+$  public-key            pass
+$  private-key           ring
+$  key-hash              @uvH
+$  signature             @
+$  message-descriptor    [=message-id encoding-num=@ num-fragments=@]
+$  message-id            [=bone =message-seq]
+$  message-seq           @ud
+$  fragment-num          @ud
+$  fragment-index        [=message-seq =fragment-num]
+$  raw-packet-hash       @uvH
+$  error                 [tag=@tas =tang]
+$  raw-packet            [[to=ship from=ship] =encoding packet-blob=@]
+$  raw-packet-blob       @uvO
+$  packet-blob           @uvO
+$  message-blob          @uvO
+$  partial-message-blob  @uvO
+$  encoding              ?(%none %open %fast %full)
::  +expiring: a value that expires at the specified date
::
+*  expiring  [value]  [expiration-date=@da value]
::  +attested: a value signed by :ship.oath to attest to its validity
::
+*  attested  [value]  [oath=[=ship =life =signature] value]
--
=<
::  vane interface core
::
|=  pit=vase
::
=|  ames-state
=*  state  -
|=  [our=ship now=@da eny=@uvJ scry-gate=sley]
=*  ames-gate  .
|%
::  +call: handle a +task:able:aloe request
::
++  call
  |=  $:  =duct
          type=*
          wrapped-task=(hobo task:able)
      ==
  ^-  [(list move) _ames-gate]
  ::  unwrap :task, coercing to valid type if needed
  ::
  =/  =task:able
    ?.  ?=(%soft -.wrapped-task)
      wrapped-task
    (task:able wrapped-task)
  ::
  =/  event-core  (per-event [our now eny scry-gate duct] state)
  ::
  =^  moves  state
    =<  abet
    ?-  -.task
      %wegh  wegh:event-core
      *      ~|  [%aloe-not-implemented -.task]  !!
    ==
  ::
  [moves ames-gate]
::  +load: migrate an old state to a new aloe version
::
++  load
  |=  old=*
  ^+  ames-gate
  ::
  ~|  %aloe-load-fail
  ames-gate(state (ames-state old))
::  +scry: handle scry request for internal state
::
++  scry
  |=  [fur=(unit (set monk)) ren=@tas why=shop syd=desk lot=coin tyl=path]
  ^-  (unit (unit cage))
  ::
  ~
::
++  stay  state
::  +take: receive response from another vane
::
++  take
  |=  [=wire =duct sign-type=type =sign:able]
  ^-  [(list move) _ames-gate]
  ::
  =/  event-core  (per-event [our now eny scry-gate duct] state)
  ::
  =^  moves  state
    =<  abet
    ?-  sign
      [%b %wake ~]  (wake:event-core wire)
      *             ~|  [%aloe-not-implemented -.sign]  !!
    ==
  ::
  [moves ames-gate]
--
::  implementation core
::
|%
++  per-event
  =|  moves=(list move)
  |=  [[our=ship now=@da eny=@ scry-gate=sley =duct] state=ames-state]
  |%
  +|  %entry-points
  ::  +wake: handle elapsed timer from behn
  ::
  ++  wake
    |=  =wire
    ^+  event-core
    !!
  ::  +wegh: report memory usage
  ::
  ++  wegh
    ^+  event-core
    %-  emit
    :^  duct  %give  %mass
    ^-  mass
    :+  %aloe  %|
    :~  dot+&+state
    ==
  ::
  +|  %utilities
  ::  +abet: finalize, producing [moves state] with moves in the right order
  ::
  ++  abet  [(flop moves) state]
  ::  +emit: enqueue an output move to be emitted at the end of the event
  ::
  ::    Prepends the move to :moves.event-core, which is reversed
  ::    at the end of an event.
  ::
  ++  emit  |=(=move event-core(moves [move moves]))
  ::
  ++  event-core  .
  --
::  |main: high-level transceiver core
::
++  main
  =>  |%
      +$  gift
        $%  [%east =duct =ship route=path payload=*]
            [%home =lane =raw-packet-blob]
            [%symmetric-key =ship (expiring =symmetric-key)]
            [%meet =ship =life =public-key]
            [%rest =duct error=(unit error)]
            [%send =lane =raw-packet-blob]
            [%veil =ship]
            [%west =ship =bone route=path payload=*]
        ==
      +$  task
        $%  [%clue =ship =pki-info]
            [%done =ship =bone error=(unit error)]
            [%hear =lane =raw-packet-blob]
            [%mess =ship =duct route=path payload=*]
            [%rend =ship =bone route=path payload=*]
            [%wake error=(unit tang)]
        ==
      --
  ::
  =|  gifts=(list gift)
  ::
  |=  $:  [now=@da eny=@ our=ship]
          =ames-state
      ==
  |%
  ++  main-core  .
  ++  abet  [(flop gifts) ames-state]
  ++  give  |=(=gift main-core(gifts [gift gifts]))
  ++  give-many
    |=(gs=(list gift) main-core(gifts `(list gift)`(weld gs gifts)))
  ::
  ++  work
    |=  =task
    ^+  main-core
    ::
    ?-  -.task
      %clue  (on-clue [ship pki-info]:task)
      %done  (on-done [ship bone error]:task)
      %hear  (on-hear [lane raw-packet-blob]:task)
      %mess  (on-mess [ship duct route payload]:task)
      %rend  (on-rend [ship bone route payload]:task)
      %wake  (on-wake error.task)
    ==
  ::  +on-clue: peer update TODO docs and comments
  ::
  ++  on-clue
    |=  [=ship =pki-info]
    ^+  main-core
    ::
    =/  ship-state  (~(got by peers.ames-state) ship)
    ?:  ?=(%peer -.ship-state)
      ::  we're not waiting for this ship; we must have it
      ::
      =.  peers.ames-state
        %+  ~(put by peers.ames-state)  ship
        ship-state(pki-info.peer-state pki-info)
      ::
      main-core
    ::  new peer; run all waiting i/o
    ::
    =/  =bone-manager  [next=2 by-duct=~ by-bone=~]
    =/  =peer-state  [pki-info lane=~ bone-manager inbound=~ outbound=~]
    =.  peers.ames-state
      (~(put by peers.ames-state) ship [%peer peer-state])
    ::
    =/  inbound   (flop inbound-packets.blocked-actions.ship-state)
    ::
    =.  main-core
      |-  ^+  main-core
      ?~  inbound  main-core
      =.  main-core  (work [%hear i.inbound])
      $(inbound t.inbound)
    ::
    =/  outbound  (flop outbound-messages.blocked-actions.ship-state)
    ::
    |-  ^+  main-core
    ?~  outbound  main-core
    =.  main-core  (work [%mess ship i.outbound])
    $(outbound t.outbound)
  ::
  ++  on-done
    |=  [=ship =bone error=(unit error)]
    ^+  main-core
    ::
    abet:(done:(per-peer ship) bone error)
  ::
  ++  on-hear
    |=  [=lane =raw-packet-blob]
    ^+  main-core
    ::
    =/  decoded=raw-packet  (decode-raw-packet raw-packet-blob)
    ?>  =(our to.decoded)
    =/  her=ship  from.decoded
    ::
    =/  ship-state  (~(get by peers.ames-state) her)
    ?:  ?=([~ %peer *] ship-state)
      =/  peer-core  (per-peer-with-state her peer-state.u.ship-state)
      =/  =raw-packet-hash  (shaf %flap raw-packet-blob)
      ::
      abet:(hear:peer-core lane raw-packet-hash [encoding packet-blob]:decoded)
    ::
    =/  =blocked-actions
      ?~  ship-state
        *blocked-actions
      blocked-actions.u.ship-state
    ::
    =.  inbound-packets.blocked-actions
      [[lane raw-packet-blob] inbound-packets.blocked-actions]
    ::
    =.  main-core  (give %veil her)
    =.  peers.ames-state
      (~(put by peers.ames-state) her [%pending-pki blocked-actions])
    ::
    main-core
  ::
  ++  on-mess
    |=  [her=ship =duct route=path payload=*]
    ^+  main-core
    ::
    =/  ship-state  (~(get by peers.ames-state) her)
    ?:  ?=([~ %peer *] ship-state)
      =/  peer-core  (per-peer-with-state her peer-state.u.ship-state)
      =^  bone  peer-core  (register-duct:peer-core duct)
      ::
      abet:(mess:peer-core bone route payload)
    ::
    =/  =blocked-actions
      ?~  ship-state
        *blocked-actions
      blocked-actions.u.ship-state
    ::
    =.  outbound-messages.blocked-actions
      [[duct route payload] outbound-messages.blocked-actions]
    ::
    ::  XX if her is comet or moon, send %open
    ::
    =.  main-core  (give %veil her)
    =.  peers.ames-state
      (~(put by peers.ames-state) her [%pending-pki blocked-actions])
    ::
    main-core
  ::
  ++  on-rend
    |=  [=ship =bone route=path payload=*]
    ^+  main-core
    ::
    abet:(mess:(per-peer ship) bone route payload)
  ::  TODO refactor
  ::
  ++  on-wake
    |=  error=(unit tang)
    ^+  main-core
    ::
    =/  old-peers  peers.ames-state
    ?~  peers.ames-state
      main-core
    ::
    =+  [n l r]=[n l r]:peers.ames-state
    =+  [her ship-state]=[p q]:n
    ::
    =/  lef  $(peers.ames-state l)
    =/  ryt  $(peers.ames-state r)
    =^  gifts-top  ship-state
      ?:  ?=(%pending-pki -.ship-state)
        [~ ship-state]
      =/  peer-core  (per-peer-with-state her peer-state.ship-state)
      [gifts [%peer peer-state]]:(to-wake:peer-core error)
    ::  TMI
    ::
    =>  .(peers.ames-state `_old-peers`peers.ames-state)
    ::
    =.  main-core  (give-many gifts.lef)
    =.  main-core  (give-many gifts.ryt)
    =.  main-core  (give-many gifts-top)
    ::
    =.  peers.ames-state
      :*  ^=  n  [her ship-state]
          ^=  l  peers.ames-state.lef
          ^=  r  peers.ames-state.ryt
      ==
    ::
    main-core
  ::  +per-peer: convenience constructor for |peer-core
  ::
  ++  per-peer
    |=  her=ship
    =/  ship-state  (~(got by peers.ames-state) her)
    ?>  ?=(%peer -.ship-state)
    (per-peer-with-state her peer-state.ship-state)
  ::  +per-peer-with-state: full constructor for |peer-core
  ::
  ++  per-peer-with-state
    |=  [her=ship =peer-state]
    |%
    ++  peer-core  .
    ++  give  |=(=gift peer-core(main-core (^give gift)))
    ++  give-many  |=(gs=(list gift) peer-core(main-core (^give-many gs)))
    ++  abet
      =.  peers.ames-state
        (~(put by peers.ames-state) her [%peer peer-state])
      main-core
    ::
    ++  done
      |=  [=bone error=(unit error)]
      ^+  peer-core
      ::
      (in-task %done bone error)
    ::
    ++  handle-decoder-gifts
      |=  gifts=(list gift:message-decoder)
      ^+  peer-core
      ::
      ?~  gifts  peer-core
      =.  peer-core  (handle-decoder-gift i.gifts)
      $(gifts t.gifts)
    ::
    ++  handle-decoder-gift
      |=  =gift:message-decoder
      ^+  peer-core
      ::
      ?-    -.gift
          %fore
        ?:  =(our ship.gift)
          (give %home [lane raw-packet-blob]:gift)
        (send(her ship.gift) [`lane raw-packet-blob]:gift)
      ::
          %have  (have [bone route payload]:gift)
          %meet  (give gift)
          %rack  (to-task [bone %back raw-packet-hash error ~s0]:gift)
          %rout  peer-core(lane.peer-state `lane.gift)
          %sack  (send-ack [bone raw-packet-hash error]:gift)
          %symmetric-key  (handle-symmetric-key-gift symmetric-key.gift)
      ::
      ==
    ::
    ++  handle-encode-meal-gifts
      |=  gifts=(list gift:encode-meal)
      ^+  peer-core
      ::
      %-  give-many
      %+  turn  gifts
      |=  =gift:encode-meal
      ^-  ^gift
      ::
      ?>  ?=(%symmetric-key -.gift)
      [%symmetric-key her [expiration-date symmetric-key]:gift]
    ::
    ++  handle-message-manager-gifts
      |=  gifts=(list gift:message-manager)
      ^+  peer-core
      ::
      ?~  gifts  peer-core
      =.  peer-core  (handle-message-manager-gift i.gifts)
      $(gifts t.gifts)
    ::
    ++  handle-message-manager-gift
      |=  =gift:message-manager
      ^+  peer-core
      ::
      ?-  -.gift
          %mack
        =/  =duct  (~(got by by-bone.bone-manager.peer-state) bone.gift)
        (give %rest duct error.gift)
      ::
          %send  (send ~ raw-packet-blob.gift)
          %symmetric-key  (handle-symmetric-key-gift symmetric-key.gift)
      ==
    ::
    ++  handle-symmetric-key-gift
      |=  =symmetric-key
      ^+  peer-core
      ::
      (give %symmetric-key her (add ~m1 now) symmetric-key)
    ::  +have: receive message; relay to client vane by bone parity
    ::
    ++  have
      |=  [=bone route=path payload=*]
      ^+  peer-core
      ::  even bone means backward flow, like a subscription update; always ack
      ::
      ?:  =(0 (end 0 1 bone))
        =/  =duct  (~(got by by-bone.bone-manager.peer-state) bone)
        ::
        =.  peer-core  (in-task %done bone ~)
        (give %east duct her route payload)
      ::  odd bone, forward flow; wait for client vane to ack the message
      ::
      (give %west her bone route payload)
    ::
    ++  hear
      |=  [=lane =raw-packet-hash =encoding =packet-blob]
      ^+  peer-core
      ::
      (in-task %hear lane raw-packet-hash encoding packet-blob)
    ::
    ++  in-task
      |=  =task:message-decoder
      ^+  peer-core
      ::
      =/  decoder
        %-  message-decoder
        [her crypto-core.ames-state [pki-info inbound]:peer-state]
      ::
      =^  gifts  inbound.peer-state  abet:(work:decoder task)
      (handle-decoder-gifts gifts)
    ::
    ++  make-message-manager
      |=  [=bone =outbound-state]
      %+  message-manager
        ^-  pki-context
        [our life.ames-state crypto-core.ames-state her pki-info.peer-state]
      [now eny bone outbound-state]
    ::
    ++  mess
      |=  [=bone route=path payload=*]
      ^+  peer-core
      ::
      (to-task bone %mess route payload)
    ::  +register-duct: add map between :duct and :next bone; increment :next
    ::
    ++  register-duct
      |=  =duct
      ^-  [bone _peer-core]
      ::
      =/  bone  (~(get by by-duct.bone-manager.peer-state) duct)
      ?^  bone
        [u.bone peer-core]
      ::
      =/  next=^bone  next.bone-manager.peer-state
      ::
      :-  next
      ::
      =.  bone-manager.peer-state
        :+  next=(add 2 next)
          by-duct=(~(put by by-duct.bone-manager.peer-state) duct next)
        by-bone=(~(put by by-bone.bone-manager.peer-state) next duct)
      ::
      peer-core
    ::  +send-ack: send acknowledgment
    ::
    ++  send-ack
      |=  [=bone =raw-packet-hash error=(unit error)]
      ^+  peer-core
      ::
      =+  ^-  [gifts=(list gift:encode-meal) fragments=(list @)]
          ::
          %-  %-  encode-meal
              ^-  pki-context
              :*  our
                  life.ames-state
                  crypto-core.ames-state
                  her
                  pki-info.peer-state
              ==
          :+  now  eny
          ^-  meal
          [%back (mix bone 1) raw-packet-hash error ~s0]
      ::
      =.  peer-core  (handle-encode-meal-gifts gifts)
      ::
      |-  ^+  peer-core
      ?~  fragments  peer-core
      =.  peer-core  (send ~ i.fragments)
      $(fragments t.fragments)
    ::  +send: send raw packet; TODO document :lane arg
    ::
    ++  send
      |=  [lane=(unit lane) =raw-packet-blob]
      ^+  peer-core
      ::
      ?<  =(our her)
      =/  her-sponsors=(list ship)  her-sponsors.pki-info.peer-state
      ::
      |-  ^+  peer-core
      ?~  her-sponsors  peer-core
      ::
      =/  new-lane=(unit ^lane)
        ?:  (lth i.her-sponsors 256)
          ::  galaxies are mapped into reserved IP space, which the interpreter
          ::  converts to a DNS request
          ::
          `[%if ~2000.1.1 31.337 (mix i.her-sponsors .0.0.1.0)]
        ::
        ?:  =(her i.her-sponsors)  lane.peer-state
        =/  ship-state  (~(get by peers.ames-state) i.her-sponsors)
        ?~  ship-state
          ~
        ?:  ?=(%pending-pki -.u.ship-state)
          ~
        lane.peer-state.u.ship-state
      ::  if no lane, try next sponsor
      ::
      ?~  new-lane
        $(her-sponsors t.her-sponsors)
      ::  forwarded packets are not signed/encrypted,
      ::  because (a) we don't need to; (b) we don't
      ::  want to turn one packet into two.  the wrapped
      ::  packet may exceed 8192 bits, but it's unlikely
      ::  to blow the MTU (IP MTU == 1500).
      ::
      =?  raw-packet-blob  |(!=(her i.her-sponsors) !=(~ lane))
        ::
        %-  encode-raw-packet
        ^-  raw-packet
        :+  [our i.her-sponsors]
          %none
        (jam `meal`[%fore her lane raw-packet-blob])
      ::
      =.  peer-core  (give %send u.new-lane raw-packet-blob)
      ::  stop if we have an %if (direct) address;
      ::  continue if we only have %ix (forwarded).
      ::
      ?:  ?=(%if -.u.new-lane)
        peer-core
      $(her-sponsors t.her-sponsors)
    ::
    ++  to-task
      |=  [=bone =task:message-manager]
      ^+  peer-core
      ::
      =/  outbound  (~(get by outbound.peer-state) bone)
      =/  =outbound-state
        ?^  outbound  u.outbound
        =|  default=outbound-state
        default(metrics.pump-state (initialize-pump-metrics:pump now))
      ::
      =/  manager  (make-message-manager bone outbound-state)
      ::
      =^  gifts  outbound-state  abet:(work:manager task)
      (handle-message-manager-gifts gifts)
    ::
    ++  to-wake
      |=  error=(unit tang)
      ^+  peer-core
      ::
      ?~  outbound.peer-state  peer-core
      ::
      =/  lef      $(outbound.peer-state l.outbound.peer-state)
      =/  ryt      $(outbound.peer-state r.outbound.peer-state)
      =/  manager  (make-message-manager n.outbound.peer-state)
      =/  top      (work:manager %wake error)
      ::  TMI
      ::
      =>  %=    .
              outbound.peer-state
            `(map bone outbound-state)`outbound.peer-state
          ==
      ::
      =.  peer-core  (give-many gifts.lef)
      =.  peer-core  (give-many gifts.ryt)
      =.  peer-core  (handle-message-manager-gifts gifts.top)
      ::
      =.  outbound.peer-state
        :*  ^=  n  [bone outbound-state]:top
            ^=  l  outbound.peer-state.lef
            ^=  r  outbound.peer-state.ryt
        ==
      ::
      peer-core
    --
  --
::  |message-manager: TODO docs
::
++  message-manager
  =>  |%
      +$  gift
        $%  ::  %symmetric-key: new fast key for pki-info
            ::
            [%symmetric-key (expiring =symmetric-key)]
            ::  %mack: acknowledge a message
            ::
            [%mack =bone error=(unit error)]
            ::  %send: release a packet
            ::
            [%send =raw-packet-hash =raw-packet-blob]
        ==
      ::
      +$  task
        $%  ::  %back: process raw packet acknowledgment
            ::
            [%back =raw-packet-hash error=(unit error) lag=@dr]
            ::  %mess: send a message
            ::
            [%mess remote-route=path payload=*]
            ::  %wake: handle an elapsed timer
            ::
            [%wake error=(unit tang)]
        ==
      --
  |=  [pki-context now=@da eny=@ =bone =outbound-state]
  =*  pki-context  +<-
  =|  gifts=(list gift)
  ::
  |%
  ++  manager-core  .
  ++  abet  [gifts=(flop gifts) outbound-state=outbound-state]
  ++  view
    |%
    ++  queue-count  `@ud`~(wyt by live-messages.outbound-state)
    ++  next-wakeup  `(unit @da)`(next-wakeup:pump pump-state.outbound-state)
    --
  ++  pump-ctx  `pump-context:pump`[gifts=~ state=pump-state.outbound-state]
  ::  +work: handle +task request, producing mutant message-manager core
  ::
  ++  work
    |=  =task
    ^+  manager-core
    ::
    =~  (handle-task task)
        feed-packets-to-pump
        ack-completed-messages
    ==
  ::  +handle-task: process an incoming request
  ::
  ++  handle-task
    |=  =task
    ^+  manager-core
    ::
    ?-  -.task
      %back  (handle-packet-ack [raw-packet-hash error lag]:task)
      %mess  (handle-message-request [remote-route payload]:task)
      %wake  (wake error.task)
    ==
  ::  +drain-pump-gifts: extract and apply pump effects, clearing pump
  ::
  ++  drain-pump-gifts
    |=  pump-gifts=(list gift:pump)
    ^+  manager-core
    ?~  pump-gifts  manager-core
    ::
    =.  manager-core  (handle-pump-gift i.pump-gifts)
    ::
    $(pump-gifts t.pump-gifts)
  ::  +handle-pump-gift: process a single effect from the packet pump
  ::
  ++  handle-pump-gift
    |=  =gift:pump
    ^+  manager-core
    ::
    ?-  -.gift
      %good  (apply-packet-ack [fragment-index error]:gift)
      %send  (give [%send raw-packet-hash raw-packet-blob]:gift)
    ==
  ::  +handle-packet-ack: hear an ack; pass it to the pump
  ::
  ++  handle-packet-ack
    |=  [=raw-packet-hash error=(unit error) lag=@dr]
    ^+  manager-core
    ::
    =^  pump-gifts  pump-state.outbound-state
      (work:pump pump-ctx now %back raw-packet-hash error lag)
    ::
    (drain-pump-gifts pump-gifts)
  ::  +feed-packets-to-pump: feed the pump with as many packets as it can accept
  ::
  ++  feed-packets-to-pump
    ^+  manager-core
    ::
    =^  packets  manager-core  collect-packets
    ::
    =^  pump-gifts  pump-state.outbound-state
      (work:pump pump-ctx now %pack packets)
    ~&  %pump-gifts^(turn `(list gift:pump)`pump-gifts head)
    ::
    (drain-pump-gifts pump-gifts)
  ::  +collect-packets: collect packets to be fed to the pump
  ::
  ++  collect-packets
    =|  packets=(list raw-packet-descriptor)
    ^+  [packets manager-core]
    ::
    =/  index  till-tick.outbound-state
    =/  window-slots=@ud  (window-slots:pump metrics.pump-state.outbound-state)
    ~&  slots-pre-collect=window-slots
    ::  reverse :packets before returning, since we built it backward
    ::
    =-  [(flop -<) ->]
    ::
    |-  ^+  [packets manager-core]
    ::
    ?:  =(0 window-slots)                  [packets manager-core]
    ?:  =(index next-tick.outbound-state)  [packets manager-core]
    ::
    =^  popped  manager-core  (pop-unsent-packets index window-slots packets)
    ::
    %_  $
      index         +(index)
      window-slots  remaining-slots.popped
      packets       packets.popped
    ==
  ::  +pop-unsent-packets: unqueue up to :window-slots unsent packets to pump
  ::
  ++  pop-unsent-packets
    |=  [index=@ud window-slots=@ud packets=(list raw-packet-descriptor)]
    ^+  [[remaining-slots=window-slots packets=packets] manager-core]
    ::
    =/  =live-message  (~(got by live-messages.outbound-state) index)
    ::
    |-  ^+  [[window-slots packets] manager-core]
    ::  TODO document this condition
    ::
    ?:  |(=(0 window-slots) ?=(~ unsent-packets.live-message))
      =.  live-messages.outbound-state
        (~(put by live-messages.outbound-state) index live-message)
      [[window-slots packets] manager-core]
    ::
    %_  $
      window-slots                 (dec window-slots)
      packets                      [i.unsent-packets.live-message packets]
      unsent-packets.live-message  t.unsent-packets.live-message
    ==
  ::  +apply-packet-ack: possibly acks or nacks whole message
  ::
  ++  apply-packet-ack
    |=  [=fragment-index error=(unit error)]
    ^+  manager-core
    ::
    =/  live-message=(unit live-message)
      (~(get by live-messages.outbound-state) message-seq.fragment-index)
    ::  if we're already done with :live-message, no-op
    ::
    ?~  live-message                   manager-core
    ?~  unsent-packets.u.live-message  manager-core
    ::  if packet says message failed, save this nack and clear the message
    ::
    ?^  error
      =/  =message-seq  message-seq.fragment-index
      ~&  [%apply-packet-ack-fail message-seq]
      ::  finalize the message in :outbound-state, saving error
      ::
      =.  live-messages.outbound-state
        %+  ~(put by live-messages.outbound-state)  message-seq
        u.live-message(unsent-packets ~, error `error)
      ::  remove this message's packets from our packet pump queues
      ::
      =^  pump-gifts  pump-state.outbound-state
        (work:pump pump-ctx now %cull message-seq)
      ::
      (drain-pump-gifts pump-gifts)
    ::  sanity check: make sure we haven't acked more packets than exist
    ::
    ?>  (lth [acked-fragments total-fragments]:u.live-message)
    ::  apply the ack on this packet to our ack counter for this message
    ::
    =.  acked-fragments.u.live-message  +(acked-fragments.u.live-message)
    ::  if final packet, we know no error ([~ ~]); otherwise, unknown (~)
    ::
    =.  error.u.live-message
      ?:  =(acked-fragments total-fragments):u.live-message
        [~ ~]
      ~
    ::  update :live-messages with modified :live-message
    ::
    =.  live-messages.outbound-state
      %+  ~(put by live-messages.outbound-state)
        message-seq.fragment-index
      u.live-message
    ::
    manager-core
  ::  +handle-message-request: break a message into packets, marking as unsent
  ::
  ++  handle-message-request
    |=  [remote-route=path payload=*]
    ^+  manager-core
    ::  encode the message as packets, flipping bone parity
    ::
    =+  ^-  [meal-gifts=(list gift:encode-meal) fragments=(list @)]
        ::
        %-  (encode-meal pki-context)
        :+  now  eny
        [%bond [(mix bone 1) next-tick.outbound-state] remote-route payload]
    ::  apply :meal-gifts
    ::
    =.  gifts  (weld (flop meal-gifts) gifts)
    ::
    %_    manager-core
        next-tick.outbound-state  +(next-tick.outbound-state)
    ::
        ::  create packet data structures from fragments; store in state
        ::
        live-messages.outbound-state
      %+  ~(put by live-messages.outbound-state)  next-tick.outbound-state
      ^-  live-message
      ::
      :*  error=~
          remote-route
          total-fragments=(lent fragments)
          acked-fragments=0
          ::
          ^=  unsent-packets  ^-  (list raw-packet-descriptor)
          =/  index  0
          |-  ^-  (list raw-packet-descriptor)
          ?~  fragments  ~
          ::
          :-  ^-  raw-packet-descriptor
              ::
              :^    virgin=&
                  [index next-tick.outbound-state]
                (shaf %flap i.fragments)
              i.fragments
          ::
          $(fragments t.fragments, index +(index))
      ==
    ==
  ::  +ack-completed-messages: ack messages, then clear them from state
  ::
  ++  ack-completed-messages
    |-  ^+  manager-core
    =/  zup  (~(get by live-messages.outbound-state) till-tick.outbound-state)
    ?~  zup          manager-core
    ?~  error.u.zup  manager-core
    ::
    =.  manager-core  (give [%mack bone `(unit error)`u.error.u.zup])
    =.  live-messages.outbound-state
      (~(del by live-messages.outbound-state) till-tick.outbound-state)
    ::
    $(till-tick.outbound-state +(till-tick.outbound-state))
  ::
  ++  wake
    |=  error=(unit tang)
    ^+  manager-core
    ::
    =^  pump-gifts  pump-state.outbound-state
      (work:pump pump-ctx now %wake error)
    ::
    (drain-pump-gifts pump-gifts)
  ::
  ++  give  |=(=gift manager-core(gifts [gift gifts]))
  --
::  |pump: packet pump state machine
::
++  pump
  =>  |%
      ::  +gift: packet pump effect; either %good logical ack, or %send packet
      ::
      +$  gift
        $%  [%good =raw-packet-hash =fragment-index rtt=@dr error=(unit error)]
            [%send =raw-packet-hash =fragment-index =raw-packet-blob]
            ::  TODO [%wait @da] to set timer
        ==
      ::  +task: request to the packet pump
      ::
      +$  task
        $%  ::  %back: raw acknowledgment
            ::
            ::    raw-packet-hash: the hash of the packet we're acknowledging
            ::    error: non-null if negative acknowledgment (nack)
            ::    lag: self-reported computation lag, to be factored out of RTT
            ::
            [%back =raw-packet-hash error=(unit error) lag=@dr]
            ::  %cull: cancel message
            ::
            [%cull =message-seq]
            ::  %pack: enqueue packets for sending
            ::
            [%pack packets=(list raw-packet-descriptor)]
            ::  %wake: timer expired
            ::
            ::    TODO: revisit after timer refactor
            ::
            [%wake error=(unit tang)]
        ==
      ::  +pump-context: mutable state for running the pump
      ::
      +$  pump-context  [gifts=(list gift) state=pump-state]
      --
  |%
  ::  +work: handle +task request, producing effects and new +pump-state
  ::
  ++  work
    |=  [ctx=pump-context now=@da =task]
    ^-  pump-context
    ::  reverse effects before returning, since we prepend them as we run
    ::
    =-  [(flop gifts.-) state.-]
    ^-  pump-context
    ::
    ?-  -.task
      %back  (back ctx now [raw-packet-hash error lag]:task)
      %cull  [gifts.ctx (cull state.ctx message-seq.task)]
      %pack  (send-packets ctx now packets.task)
      %wake  [gifts.ctx (wake state.ctx now error.task)]
    ==
  ::  +abet: finalize before returning, reversing effects
  ::
  ++  abet
    |=  ctx=pump-context
    ^-  pump-context
    [(flop gifts.ctx) state.ctx]
  ::  +next-wakeup: when should this core wake back up to do more processing?
  ::
  ::    Produces null if no wakeup needed.
  ::    TODO: call in +abet to produce a set-timer effect
  ::
  ++  next-wakeup
    |=  state=pump-state
    ^-  (unit @da)
    ::
    =/  next=(unit live-raw-packet)  ~(top to live.state)
    ?~  next
      ~
    `expiration-date.u.next
  ::  +window-slots: how many packets can be sent before window fills up?
  ::
  ::   Called externally to query window information.
  ::
  ++  window-slots
    |=  metrics=pump-metrics
    ^-  @ud
    ::
    %+  sub-safe  max-packets-out.metrics
    (add [window-length retry-length]:metrics)
  ::  +initialize-pump-metrics: make blank metrics from :now, stateless
  ::
  ++  initialize-pump-metrics
    |=  now=@da
    ^-  pump-metrics
    ::
    :*  :*  ^=  window-length    0
            ^=  max-packets-out  2
            ^=  retry-length     0
        ==
        :*  ^=  rtt              ~s5
            ^=  last-sent        `@da`(sub now ~d1)
            ^=  last-deadline    `@da`(sub now ~d1)
    ==  ==
  ::  +back: process raw ack
  ::
  ::    TODO: better docs
  ::    TODO: test to verify queue invariants
  ::
  ++  back
    |=  [ctx=pump-context now=@da =raw-packet-hash error=(unit error) lag=@dr]
    ^-  pump-context
    ::  post-process by adjusting timing information and losing packets
    ::
    =-  =.  live.state.ctx  lov
        =.  state.ctx  (lose state.ctx ded)
        ::  rtt: roundtrip time, subtracting reported computation :lag
        ::
        =/  rtt=@dr
          ?~  ack  ~s0
          (sub-safe (sub now sent-date.u.ack) lag)
        ::
        (done ctx ack raw-packet-hash error rtt)
    ::  liv: iteratee starting as :live.state.ctx
    ::
    =/  liv=(qeu live-raw-packet)  live.state.ctx
    ::  main loop
    ::
    |-  ^-  $:  ack=(unit live-raw-packet)
                ded=(list live-raw-packet)
                lov=(qeu live-raw-packet)
            ==
    ?~  liv  [~ ~ ~]
    ::  ryt: result of searching the right (front) side of the queue
    ::
    =+  ryt=$(liv r.liv)
    ::  found in front; no need to search back
    ::
    ?^  ack.ryt  [ack.ryt ded.ryt liv(r lov.ryt)]
    ::  lose unacked packets sent before an acked virgin.
    ::
    ::    Uses head recursion to produce :ack, :ded, and :lov.
    ::
    =+  ^-  $:  top=?
                ack=(unit live-raw-packet)
                ded=(list live-raw-packet)
                lov=(qeu live-raw-packet)
            ==
        ?:  =(raw-packet-hash raw-packet-hash.raw-packet-descriptor.n.liv)
          [| `n.liv ~ l.liv]
        [& $(liv l.liv)]
    ::
    ?~  ack  [~ ~ liv]
    ::
    =*  virgin  virgin.raw-packet-descriptor.u.ack
    ::
    =?  ded  top     [n.liv ded]
    =?  ded  virgin  (weld ~(tap to r.liv) ded)
    =?  lov  top     [n.liv lov ~]
    ::
    [ack ded lov]
  ::  +cancel-message: unqueue all packets from :message-seq
  ::
  ::    Clears all packets from a message from the :live and :lost queues.
  ::
  ::    TODO test
  ::    TODO: shouldn't this adjust the accounting in :pump-metrics?
  ::          specifically, :retry-length and :window-length
  ::
  ++  cull
    |=  [state=pump-state =message-seq]
    ^-  pump-state
    ::
    =.  live.state
      =/  liv  live.state
      |-  ^+  live.state
      ?~  liv  ~
      ::  first recurse on left and right trees
      ::
      =/  vil  liv(l $(liv l.liv), r $(liv r.liv))
      ::  if the head of the tree is from the message to be deleted, cull it
      ::
      ?.  =(message-seq message-seq.fragment-index.raw-packet-descriptor.n.liv)
        vil
      ~(nip to `(qeu live-raw-packet)`vil)
    ::
    =.  lost.state
      =/  lop  lost.state
      |-  ^+  lost.state
      ?~  lop  ~
      ::  first recurse on left and right trees
      ::
      =/  pol  lop(l $(lop l.lop), r $(lop r.lop))
      ::  if the head of the tree is from the message to be deleted, cull it
      ::
      ?.  =(message-seq message-seq.fragment-index.n.lop)
        pol
      ~(nip to `(qeu raw-packet-descriptor)`pol)
    ::
    state
  ::  +done: process a cooked ack; may emit a %good ack gift
  ::
  ++  done
    |=  $:  ctx=pump-context
            live-raw-packet=(unit live-raw-packet)
            =raw-packet-hash
            error=(unit error)
            rtt=@dr
        ==
    ^-  pump-context
    ?~  live-raw-packet  ctx
    ::
    =*  fragment-index  fragment-index.raw-packet-descriptor.u.live-raw-packet
    =.  ctx  (give ctx [%good raw-packet-hash fragment-index rtt error])
    ::
    =.  window-length.metrics.state.ctx  (dec window-length.metrics.state.ctx)
    ::
    ctx
  ::  +enqueue-lost-raw-packet: ordered enqueue into :lost.pump-state
  ::
  ::    The :lost queue isn't really a queue in case of
  ::    resent packets; packets from older messages
  ::    need to be sent first. Unfortunately hoon.hoon
  ::    lacks a general sorted/balanced heap right now.
  ::    so we implement a balanced queue insert by hand.
  ::
  ::    This queue is ordered by:
  ::      - message sequence number
  ::      - fragment number within the message
  ::      - raw-packet-hash
  ::
  ::    TODO: why do we need the packet-hash tiebreaker?
  ::    TODO: write queue order function
  ::
  ++  enqueue-lost-raw-packet
    |=  [state=pump-state pac=raw-packet-descriptor]
    ^+  lost.state
    ::
    =/  lop  lost.state
    ::
    |-  ^+  lost.state
    ?~  lop  [pac ~ ~]
    ::
    ?:  ?|  (older fragment-index.pac fragment-index.n.lop)
            ?&  =(fragment-index.pac fragment-index.n.lop)
                (lth raw-packet-hash.pac raw-packet-hash.n.lop)
        ==  ==
      lop(r $(lop r.lop))
    lop(l $(lop l.lop))
  ::  +fire-raw-packet: emit a %send gift for a packet and do bookkeeping
  ::
  ++  fire-raw-packet
    |=  [ctx=pump-context now=@da pac=raw-packet-descriptor]
    ^-  pump-context
    ::  metrics: read-only accessor for convenience
    ::
    =/  metrics  metrics.state.ctx
    ::  sanity check: make sure we don't exceed the max packets in flight
    ::
    ?>  (lth [window-length max-packets-out]:metrics)
    ::  reset :last-sent date to :now or incremented previous value
    ::
    =.  last-sent.metrics.state.ctx
      ?:  (gth now last-sent.metrics)
        now
      +(last-sent.metrics)
    ::  reset :last-deadline to twice roundtrip time from now, or increment
    ::
    =.  last-deadline.metrics.state.ctx
      =/  new-deadline=@da  (add now (mul 2 rtt.metrics))
      ?:  (gth new-deadline last-deadline.metrics)
        new-deadline
      +(last-deadline.metrics)
    ::  increment our count of packets in flight
    ::
    =.  window-length.metrics.state.ctx  +(window-length.metrics.state.ctx)
    ::  register the packet in the :live queue
    ::
    =.  live.state.ctx
      %-  ~(put to live.state.ctx)
      ^-  live-raw-packet
      :+  last-deadline.metrics.state.ctx
        last-sent.metrics.state.ctx
      pac
    ::  emit the packet
    ::
    (give ctx [%send raw-packet-hash fragment-index raw-packet-blob]:pac)
  ::  +lose: abandon packets
  ::
  ++  lose
    |=  [state=pump-state packets=(list live-raw-packet)]
    ^-  pump-state
    ?~  packets  state
    ::
    =.  lost.state  (enqueue-lost-raw-packet state raw-packet-descriptor.i.packets)
    ::
    %=  $
      packets                      t.packets
      window-length.metrics.state  (dec window-length.metrics.state)
      retry-length.metrics.state   +(retry-length.metrics.state)
    ==
  ::  +send-packets: resends lost packets then sends new until window closes
  ::
  ++  send-packets
    |=  [ctx=pump-context now=@da packets=(list raw-packet-descriptor)]
    ^-  pump-context
    =-  ~&  %send-packets^requested=(lent packets)^sent=(lent gifts.-)  -
    ::  make sure we weren't asked to send more packets than allowed
    ::
    =/  slots  (window-slots metrics.state.ctx)
    ?>  (lte (lent packets) slots)
    ::
    |-  ^+  ctx
    ?:  =(0 slots)  ctx
    ?~  packets     ctx
    ::  first, resend as many lost packets from our backlog as possible
    ::
    ?.  =(~ lost.state.ctx)
      =^  lost-raw-packet  lost.state.ctx  ~(get to lost.state.ctx)
      =.  retry-length.metrics.state.ctx  (dec retry-length.metrics.state.ctx)
      ::
      =.  ctx  (fire-raw-packet ctx now lost-raw-packet)
      $(slots (dec slots))
    ::  now that we've finished the backlog, send the requested packets
    ::
    =.  ctx  (fire-raw-packet ctx now i.packets)
    $(packets t.packets, slots (dec slots))
  ::  +wake: handle elapsed timer
  ::
  ++  wake
    |=  [state=pump-state now=@da error=(unit tang)]
    ^-  pump-state
    ::
    ?^  error  ~|(%ames-todo-handle-timer-error^u.error !!)
    ::
    =-  =.  live.state  live.-
        (lose state dead.-)
    ::
    ^-  [dead=(list live-raw-packet) live=(qeu live-raw-packet)]
    ::
    =|  dead=(list live-raw-packet)
    =/  live=(qeu live-raw-packet)  live.state
    ::  binary search through :live for dead packets
    ::
    ::    The :live packet tree is sorted right-to-left by the packets'
    ::    lost-by deadlines. Packets with later deadlines are on the left.
    ::    Packets with earlier deadlines are on the right.
    ::
    ::    Start by examining the packet at the tree's root.
    ::
    ::      If the tree is empty (~):
    ::
    ::    We're done. Produce the empty tree and any dead packets we reaped.
    ::
    ::      If the root packet is dead:
    ::
    ::    Kill everything to its right, since all those packets have older
    ::    deadlines than the root and will also be dead. Then recurse on
    ::    the left node, since the top node might not have been the newest
    ::    packet that needs to die.
    ::
    ::      If the root packet is alive:
    ::
    ::    Recurse to the right, which will look for older packets
    ::    to be marked dead. Replace the right side of the :live tree with
    ::    the modified tree resulting from the recursion.
    ::
    |-  ^+  [dead=dead live=live]
    ?~  live  [dead ~]
    ::  if packet at root of queue is dead, everything to its right is too
    ::
    ?:  (gte now expiration-date.n.live)
      $(live l.live, dead (welp ~(tap to r.live) [n.live dead]))
    ::  otherwise, replace right side of tree with recursion result
    ::
    =/  right-result  $(live r.live)
    [dead.right-result live(r live.right-result)]
  ::  +give: emit effect, prepended to :gifts to be reversed before emission
  ::
  ++  give
    |=  [ctx=pump-context =gift]
    ^-  pump-context
    [[gift gifts.ctx] state.ctx]
  --
::  +encode-meal: generate a message and packets from a +meal, with effects
::
++  encode-meal
  =>  |%
      ::  +gift: side effect
      ::
      +$  gift
        $%  ::  %line: set symmetric key
            ::
            ::    Connections start as %full, which uses asymmetric encryption.
            ::    This core can produce an upgrade to a shared symmetric key,
            ::    which is much faster; hence the %fast tag on that encryption.
            ::
            [%symmetric-key (expiring =symmetric-key)]
        ==
      --
  ::  outer gate: establish pki context, producing inner gate
  ::
  |=  pki-context
  ::  inner gate: process a meal, producing side effects and packets
  ::
  |=  [now=@da eny=@ =meal]
  ::
  |^  ^-  [gifts=(list gift) parts=(list partial-message-blob)]
      ::
      =+  ^-  [gifts=(list gift) =encoding =message-blob]  generate-message
      ::
      [gifts (generate-fragments encoding message-blob)]
  ::  +generate-fragments: split a message into packets
  ::
  ++  generate-fragments
    |=  [=encoding =message-blob]
    ^-  (list partial-message-blob)
    ::  total-fragments: number of packets for message
    ::
    ::    Each packet has max 2^13 bits so it fits in the MTU on most systems.
    ::
    =/  total-fragments=fragment-num  (met 13 message-blob)
    ::  if message fits in one packet, don't fragment
    ::
    ?:  =(1 total-fragments)
      [(encode-raw-packet [our her] encoding message-blob) ~]
    ::  fragments: fragments generated from splitting message
    ::
    =/  fragments=(list @)  (rip 13 message-blob)
    =/  fragment-index=fragment-num  0
    ::  wrap each fragment in a %none encoding of a %carp meal
    ::
    |-  ^-  (list partial-message-blob)
    ?~  fragments  ~
    ::
    :-  ^-  partial-message-blob
        %^  encode-raw-packet  [our her]  %none
        %-  jam
        ^-  ^meal
        :+  %carp
          ^-  message-descriptor
          [(get-message-id meal) (encoding-to-number encoding) total-fragments]
        [fragment-index i.fragments]
    ::
    $(fragments t.fragments, fragment-index +(fragment-index))
  ::  +generate-message: generate message from meal
  ::
  ++  generate-message
    ^-  [gifts=(list gift) =encoding =message-blob]
    ::  if :meal is just a single fragment, don't bother double-encrypting it
    ::
    ?:  =(%carp -.meal)
      [gifts=~ encoding=%none message-blob=(jam meal)]
    ::  if this channel has a symmetric key, use it to encrypt
    ::
    ?^  fast-key.pki-info
      :-  ~
      :-  %fast
      %^  cat  7
        key-hash.u.fast-key.pki-info
      (en:crub:crypto symmetric-key.key.u.fast-key.pki-info (jam meal))
    ::  asymmetric encrypt; also produce symmetric key gift for upgrade
    ::
    ::    Generate a new symmetric key by hashing entropy, the date,
    ::    and an insecure hash of :meal. We might want to change this to use
    ::    a key derived using Diffie-Hellman.
    ::
    =/  new-symmetric-key=symmetric-key  (shaz :(mix (mug meal) now eny))
    ::  expire the key in one month
    ::  TODO: when should the key expire?
    ::
    :-  [%symmetric-key `@da`(add now ~m1) new-symmetric-key]~
    :-  %full
    %-  jam
    ::
    ^-  full:packet-format
    ::  TODO: send our deed if we're a moon or comet
    ::
    :+  [to=her-life.pki-info from=our-life]  deed=~
    ::  encrypt the pair of [new-symmetric-key (jammed-meal)] for her eyes only
    ::
    ::    This sends the new symmetric key by piggy-backing it onto the
    ::    original message.
    ::
    %+  seal:as:crypto-core
      (~(got by her-public-keys.pki-info) her-life.pki-info)
    (jam [new-symmetric-key (jam meal)])
  --
::  |message-decoder: decode and assemble input packets into messages
::
::    TODO: document
::
++  message-decoder
  =>  |%
      +$  gift
        $%  [%fore =ship =lane =raw-packet-blob]
            [%have =bone route=path payload=*]
            [%symmetric-key =symmetric-key]
            [%meet =ship =life =public-key]
            [%rack =bone =raw-packet-hash error=(unit error)]
            [%rout =lane]
            [%sack =bone =raw-packet-hash error=(unit error)]
        ==
      +$  task
        $%  [%done =bone error=(unit error)]
            [%hear =lane =raw-packet-hash =encoding =packet-blob]
        ==
      --
  ::
  =|  gifts=(list gift)
  ::
  |=  $:  her=ship
          crypto-core=acru:ames
          =pki-info
          bone-states=(map bone inbound-state)
      ==
  |%
  ++  decoder-core  .
  ++  abet  [(flop gifts) bone-states]
  ++  give  |=(=gift decoder-core(gifts [gift gifts]))
  ::
  ++  decode-packet
    |=  [=encoding =packet-blob]
    ^-  [[authenticated=? =meal] _decoder-core]
    ::
    =+  ^-  [gifts=(list gift:interpret-packet) authenticated=? =meal]
        ::
        %-  (interpret-packet her crypto-core pki-info)
        [encoding packet-blob]
    ::
    :-  [authenticated meal]
    |-  ^+  decoder-core
    ::
    ?~  gifts  decoder-core
    =.  decoder-core  (give i.gifts)
    $(gifts t.gifts)
  ::
  ++  work
    |=  =task
    ^+  decoder-core
    ::
    ?-    -.task
        %done
      =/  =inbound-state  (~(got by bone-states) bone.task)
      =/  to-apply  (need awaiting-application.inbound-state)
      ::
      =/  assembler
        %-  message-assembler  :*
          bone.task
          message-seq.to-apply
          authenticated=%.y
          raw-packet-hash.to-apply
          lane.to-apply
          inbound-state
        ==
      ::
      abet:(on-message-completed:assembler error.task)
    ::
        %hear
      =^  decoded  decoder-core  (decode-packet [encoding packet-blob]:task)
      ::
      =?  decoder-core  authenticated.decoded  (give %rout lane.task)
      ::
      =/  =meal  meal.decoded
      ?-    -.meal
          ::  %back: we heard an ack; emit an ack move internally
          ::
          %back
        ~|  %unauthenticated-ack-from^her
        ?>  authenticated.decoded
        (give %rack [bone raw-packet-hash error]:meal)
      ::
          ::  %bond: we heard a full-message packet; assemble and process it
          ::
          %bond
        =/  =inbound-state
          %-  fall  :_  *inbound-state
          (~(get by bone-states) bone.message-id.meal)
        ::
        =/  assembler
          %-  message-assembler  :*
            bone.message-id.meal
            message-seq.message-id.meal
            authenticated.decoded
            raw-packet-hash.task
            lane.task
            inbound-state
          ==
        ::
        abet:(on-bond:assembler [remote-route payload]:meal)
      ::
          ::  %carp: we heard a message fragment; try to assemble into a message
          ::
          %carp
        =/  =message-id  message-id.message-descriptor.meal
        ::
        =/  =inbound-state
          %-  fall  :_  *inbound-state
          (~(get by bone-states) bone.message-id)
        ::
        =/  assembler
          %-  message-assembler  :*
            bone.message-id
            message-seq.message-id
            authenticated.decoded
            raw-packet-hash.task
            lane.task
            inbound-state
          ==
        ::
        =-  abet:(on-carp:assembler -)
        ::
        ::  TODO: assert meal and task encodings match?
        ::
        :*  (number-to-encoding encoding-num.message-descriptor.meal)
            num-fragments.message-descriptor.meal
            fragment-num.meal
            partial-message-blob.meal
        ==
      ::
          ::  %fore: we heard a packet to forward; convert origin and pass it on
          ::
          %fore
        =/  =lane  (set-forward-origin lane.task lane.meal)
        (give %fore ship.meal lane raw-packet-blob.meal)
      ==
    ::
    ==
  ::  |message-assembler: core for assembling received packets into messages
  ::
  ++  message-assembler
    |=  $:  =bone
            =message-seq
        ::
            authenticated=?
            =raw-packet-hash
            =lane
        ::
            =inbound-state
        ==
    |%
    ++  assembler-core  .
    ++  abet
      decoder-core(bone-states (~(put by bone-states) bone inbound-state))
    ::
    ++  give  |=(=gift assembler-core(decoder-core (^give gift)))
    ::
    ++  give-ack
      |=  error=(unit error)
      ^+  assembler-core
      (give %sack bone raw-packet-hash error)
    ::
    ++  give-duplicate-ack
      (give-ack (~(get by nacks.inbound-state) message-seq))
    ::
    ++  on-message-completed
      |=  error=(unit error)
      ^+  assembler-core
      ::
      =.  last-acked.inbound-state  +(last-acked.inbound-state)
      =.  awaiting-application.inbound-state  ~
      ::
      =?  nacks.inbound-state  ?=(^ error)
        (~(put by nacks.inbound-state) message-seq u.error)
      ::
      (give-ack error)
    ::  +on-bond: handle a packet containing a full message
    ::
    ++  on-bond
      |=  [route=path payload=*]
      ^+  assembler-core
      ::  if we already acked this message, ack it again
      ::  if later than next expected message or already being processed, ignore
      ::
      ?:  (lth message-seq last-acked.inbound-state)  give-duplicate-ack
      ?:  (gth message-seq last-acked.inbound-state)  assembler-core
      ?.  =(~ awaiting-application.inbound-state)     assembler-core
      ::  record message as in-process and delete partial message
      ::
      =.  awaiting-application.inbound-state
        `[message-seq raw-packet-hash lane]
      =.  partial-messages.inbound-state
        (~(del by partial-messages.inbound-state) message-seq)
      ::
      (give [%have bone route payload])
    ::  +on-carp: add a fragment to a partial message, possibly completing it
    ::
    ++  on-carp
      |=  [=encoding count=@ud =fragment-num =partial-message-blob]
      ^+  assembler-core
      ::
      ?:  (lth message-seq last-acked.inbound-state)  give-duplicate-ack
      ?:  (gth message-seq last-acked.inbound-state)  assembler-core
      ::
      =/  =partial-message
        %+  fall  (~(get by partial-messages.inbound-state) message-seq)
        [encoding num-received=0 next-fragment=count fragments=~]
      ::  all fragments must agree on the message parameters
      ::
      ?>  =(encoding.partial-message encoding)
      ?>  (gth next-fragment.partial-message fragment-num)
      ?>  =(next-fragment.partial-message count)
      ::
      ?:  (~(has by fragments.partial-message) fragment-num)
        give-duplicate-ack
      ::  register this fragment in the state
      ::
      =.  num-received.partial-message  +(num-received.partial-message)
      =.  fragments.partial-message
        (~(put by fragments.partial-message) fragment-num partial-message-blob)
      ::  if we haven't received all fragments, update state and ack packet
      ::
      ?.  =(num-received next-fragment):partial-message
        =.  fragments.partial-message
          (~(put by fragments.partial-message) message-seq partial-message-blob)
        ::
        (give-ack ~)
      ::  assemble and decode complete message
      ::
      =/  =message-blob
        (assemble-fragments [next-fragment fragments]:partial-message)
      ::
      =^  decoded  decoder-core  (decode-packet encoding message-blob)
      ::
      =.  authenticated  |(authenticated authenticated.decoded)
      =*  meal  meal.decoded
      ::
      ?-    -.meal
          %back
        ~|  %ames-back-insecure-from^her
        ?>  authenticated
        (give %rack bone [raw-packet-hash error]:meal.decoded)
      ::
          %bond
        ~|  %ames-message-assembly-failed
        ?>  &(authenticated =([bone message-seq] message-id.meal))
        ::
        (on-bond [remote-route payload]:meal)
      ::
          %carp  ~|(%ames-meta-carp !!)
          %fore
        =/  adjusted-lane=^lane  (set-forward-origin lane lane.meal)
        (give %fore ship.meal adjusted-lane raw-packet-blob.meal)
      ==
    ::
    ++  assemble-fragments
      =|  index=fragment-num
      =|  sorted-fragments=(list partial-message-blob)
      ::
      |=  $:  next-fragment=fragment-num
              fragments=(map fragment-num partial-message-blob)
          ==
      ^-  message-blob
      ::  final packet; concatenate fragment buffers
      ::
      ?:  =(next-fragment index)
        %+  can  13
        %+  turn  (flop sorted-fragments)
        |=(a=@ [1 a])
      ::  not the final packet; find fragment by index and prepend to list
      ::
      =/  current-fragment=partial-message-blob  (~(got by fragments) index)
      $(index +(index), sorted-fragments [current-fragment sorted-fragments])
    --
  --
::  +interpret-packet: authenticate and decrypt a packet, effectfully
::
++  interpret-packet
  =>  |%
      +$  gift
        $%  [%symmetric-key =symmetric-key]
            [%meet =ship =life =public-key]
        ==
      --
  ::  outer gate: establish context
  ::
  ::    her:             ship that sent us the message
  ::    our-private-key: our private key at current life
  ::    pki-info:        channel between our and her
  ::
  |=  $:  her=ship
          crypto-core=acru:ames
          =pki-info
      ==
  ::  inner gate: decode a packet
  ::
  |=  [=encoding =packet-blob]
  ^-  [gifts=(list gift) authenticated=? =meal]
  ::
  =|  gifts=(list gift)
  ::
  |^  ?-  encoding
        %none  decode-none
        %open  decode-open
        %fast  decode-fast
        %full  decode-full
      ==
  ::  +decode-none: decode an unsigned, unencrypted packet
  ::
  ++  decode-none
    ^-  [gifts=(list gift) authenticated=? =meal]
    ::
    (produce-meal authenticated=%.n packet-blob)
  ::  +decode-open: decode a signed, unencrypted packet
  ::
  ++  decode-open
    ^-  [gifts=(list gift) authenticated=? =meal]
    ::
    =/  packet-noun  (cue packet-blob)
    =/  open-packet  (open:packet-format packet-noun)
    ::
    =?    decoder-core
        ?=(^ deed.open-packet)
      (apply-deed u.deed.open-packet)
    ::  TODO: is this assertion at all correct?
    ::  TODO: make sure the deed gets applied to the pki-info if needed
    ::
    ?>  =(her-life.pki-info from-life.open-packet)
    ::
    =/  her-public-key
      (~(got by her-public-keys.pki-info) her-life.pki-info)
    ::
    %+  produce-meal  authenticated=%.y
    %-  need
    (extract-signed her-public-key signed-payload.open-packet)
  ::  +decode-fast: decode a packet with symmetric encryption
  ::
  ++  decode-fast
    ^-  [gifts=(list gift) authenticated=? =meal]
    ::
    ?~  fast-key.pki-info
      ~|  %ames-no-fast-key^her  !!
    ::
    =/  key-hash=@   (end 7 1 packet-blob)
    =/  payload=@    (rsh 7 1 packet-blob)
    ::
    ~|  [%ames-bad-fast-key `@ux`key-hash `@ux`key-hash.u.fast-key.pki-info]
    ?>  =(key-hash key-hash.u.fast-key.pki-info)
    ::
    %+  produce-meal  authenticated=%.y
    %-  need
    (de:crub:crypto symmetric-key.key.u.fast-key.pki-info payload)
  ::  +decode-full: decode a packet with asymmetric encryption
  ::
  ++  decode-full
    ^-  [gifts=(list gift) authenticated=? =meal]
    ::
    =/  packet-noun  (cue packet-blob)
    =/  full-packet  (full:packet-format packet-noun)
    ::
    =?    decoder-core
        ?=(^ deed.full-packet)
      (apply-deed u.deed.full-packet)
    ::  TODO: is this assertion valid if we hear a new deed?
    ::
    ~|  [%ames-life-mismatch her her-life.pki-info from-life.full-packet]
    ?>  =(her-life.pki-info from-life.full-packet)
    ::
    =/  her-public-key
      (~(got by her-public-keys.pki-info) her-life.pki-info)
    =/  jammed-wrapped=@
      %-  need
      (tear:as:crypto-core her-public-key encrypted-payload.full-packet)
    ::
    =+  %-  ,[=symmetric-key jammed-packet=@]
        (cue jammed-wrapped)
    ::
    =.  decoder-core  (give %symmetric-key symmetric-key)
    =.  decoder-core  (give %meet her her-life.pki-info her-public-key)
    ::
    (produce-meal authenticated=%.y jammed-packet)
  ::  +apply-deed: produce a %meet gift if the deed checks out
  ::
  ++  apply-deed
    |=  =deed
    ^+  decoder-core
    ::
    =+  [expiration-date life public-key signature]=deed
    ::  if we already know the public key for this life, noop
    ::
    ?:  =(`public-key (~(get by her-public-keys.pki-info) life))
      decoder-core
    ::  TODO: what if the deed verifies at the same fife for :her?
    ::
    ?>  (verify-deed deed)
    ::
    (give %meet her life public-key)
  ::  +verify-deed: produce %.y iff deed is valid
  ::
  ::    TODO: actually implement; this is just a stub
  ::
  ++  verify-deed
    |=  =deed
    ^-  ?
    ::  if :her is anything other than a moon or comet, the deed is invalid
    ::
    ?+    (clan:title her)  %.n
        ::  %earl: :her is a moon, with deed signed by numeric parent
        ::
        %earl
      ~|  %ames-moons-not-implemented  !!
    ::
        ::  %pawn: comet, self-signed, life 1, address is fingerprint
        ::
        %pawn
      ~|  %ames-comets-not-implemented  !!
    ==
  ::  +give: emit +gift effect, to be flopped later
  ::
  ++  give  |=(=gift decoder-core(gifts [gift gifts]))
  ::  +produce-meal: exit this core with a +meal +cue'd from :meal-precursor
  ::
  ++  produce-meal
    |=  [authenticated=? meal-precursor=@]
    ^-  [gifts=(list gift) authenticated=? =meal]
    ::
    :+  (flop gifts)  authenticated
    %-  meal
    (cue meal-precursor)
  ::
  ++  decoder-core  .
  --
::  +decode-raw-packet: deserialize packet from bytestream, reading header
::
++  decode-raw-packet
  |=  =raw-packet-blob
  ^-  raw-packet
  ::  first 32 (2^5) bits are header; the rest is body
  ::
  =/  header  (end 5 1 raw-packet-blob)
  =/  body    (rsh 5 1 raw-packet-blob)
  ::
  =/  version           (end 0 3 header)
  =/  checksum          (cut 0 [3 20] header)
  =/  receiver-width    (decode-ship-type (cut 0 [23 2] header))
  =/  sender-width      (decode-ship-type (cut 0 [25 2] header))
  =/  message-encoding  (number-to-encoding (cut 0 [27 5] header))
  ::
  ?>  =(protocol-version version)
  ?>  =(checksum (end 0 20 (mug body)))
  ::
  :+  :-  to=(end 3 receiver-width body)
      from=(cut 3 [receiver-width sender-width] body)
    encoding=message-encoding
  packet=(rsh 3 (add receiver-width sender-width) body)
::  +encode-raw-packet: serialize a packet into a bytestream
::
++  encode-raw-packet
  |=  =raw-packet
  ^-  raw-packet-blob
  ::
  =/  receiver-type   (encode-ship-type to.raw-packet)
  =/  receiver-width  (bex +(receiver-type))
  ::
  =/  sender-type   (encode-ship-type from.raw-packet)
  =/  sender-width  (bex +(sender-type))
  ::  body: <<receiver sender content>>
  ::
  =/  body
    ;:  mix
      to.raw-packet
      (lsh 3 receiver-width from.raw-packet)
      (lsh 3 (add receiver-width sender-width) packet-blob.raw-packet)
    ==
  ::
  =/  encoding-number  (encoding-to-number encoding.raw-packet)
  ::  header: 32-bit header assembled from bitstreams of fields
  ::
  ::    <<protocol-version checksum receiver-type sender-type encoding>>
  ::
  =/  header
    %+  can  0
    :~  [3 protocol-version]
        [20 (mug body)]
        [2 receiver-type]
        [2 sender-type]
        [5 encoding-number]
    ==
  ::  result is <<header body>>
  ::
  (mix header (lsh 5 1 body))
::  +decode-ship-type: decode a 2-bit ship type specifier into a byte width
::
::    Type 0: galaxy or star -- 2 bytes
::    Type 1: planet         -- 4 bytes
::    Type 2: moon           -- 8 bytes
::    Type 3: comet          -- 16 bytes
::
++  decode-ship-type
  |=  ship-type=@
  ^-  @
  ::
  ?+  ship-type  ~|  %invalid-ship-type  !!
    %0  2
    %1  4
    %2  8
    %3  16
  ==
::  +encode-ship-type: produce a 2-bit number representing :ship's address type
::
::    0: galaxy or star
::    1: planet
::    2: moon
::    3: comet
::
++  encode-ship-type
  |=  =ship
  ^-  @
  ::
  =/  bytes  (met 3 ship)
  ::
  ?:  (lte bytes 2)  0
  ?:  (lte bytes 4)  1
  ?:  (lte bytes 8)  2
  3
::  +number-to-encoding: read a number off the wire into an encoding type
::
++  number-to-encoding
  |=  number=@
  ^-  encoding
  ?+  number  ~|  %invalid-encoding  !!
    %0  %none
    %1  %open
    %2  %fast
    %3  %full
  ==
::  +encoding-to-number: convert encoding to wire-compatible enumeration
::
++  encoding-to-number
  |=  =encoding
  ^-  @
  ::
  ?-  encoding
    %none  0
    %open  1
    %fast  2
    %full  3
  ==
::  +get-message-id: extract message-id from a +meal or default to initial value
::
++  get-message-id
  |=  =meal
  ^-  message-id
  ?+  -.meal  [0 0]
    %bond  message-id.meal
    %carp  message-id.message-descriptor.meal
  ==
::  +set-forward-origin: adjust origin address for forwarded packet
::
::    A forwarded packet contains its origin address,
::    but only after the first hop. If the address
::    field is empty, we fill it in with the address
::    we received the packet from. But we replace
::    %if with %ix, to show that the ultimate receiver
::    may not be able to send back to the origin
::    (due to non-full-cone NAT).
::
++  set-forward-origin
  |=  [=new=lane origin=(unit lane)]
  ^-  lane
  ::
  ?~  origin  new-lane
  ?.  ?=(%if -.u.origin)
    u.origin
  [%ix +.u.origin]
::  +extract-signed: if valid signature, produce extracted value; else produce ~
::
++  extract-signed
  |=  [=public-key signed-buffer=@]
  ^-  (unit @)
  ::
  (sure:as:(com:nu:crub:crypto public-key) signed-buffer)
::  +older: is fragment-index :a older than fragment-index :b?
::
++  older
  |=  [a=fragment-index b=fragment-index]
  ^-  ?
  ?:  (lth message-seq.a message-seq.b)
    %.y
  ::
  ?&  =(message-seq.a message-seq.b)
      (lth fragment-num.a fragment-num.b)
  ==
::  +sub-safe: subtract :b from :a unless :a is bigger, in which case produce 0
::
++  sub-safe
  |=  [a=@ b=@]
  ^-  @
  ?:  (lth a b)
    0
  (sub a b)
--
