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
  $:  inbound-packets=(list [=lane =raw-packet-hash =raw-packet])
      outbound-messages=(list [=duct route=path payload=*])
  ==
::  +inbound-state: per-bone receive state
::
::    We only listen for packets from a single message at a time. This is the
::    :live-message. As soon as we finish receiving all packets for this
::    message, we increment :last-heard. If there is no :pending-vane-ack, we
::    relay the message to our local client vane for processing.
::
::    When the vane acks the message, we increment :last-acked,
::    ack the last packet we received from that message, and
::    clear :pending-vane-ack. If another message has been completely received,
::    we clear it from :live-message, relay it to the local client vane, and
::    set it as :pending-vane-ack.
::
::    last-acked: last message acked by local client vane
::    last-heard: last message we've completely received
::    pending-vane-ack: message waiting on ack from local client vane
::    live-message: partially received message
::    nacks: messages we've nacked but whose nacksplanations have not been acked
::
+$  inbound-state
  $:  last-acked=message-seq
      last-heard=message-seq
      pending-vane-ack=(qeu [=message-seq =message])
      live-messages=(map message-seq live-hear-message)
      nacks=(set message-seq)
  ==
::  +live-hear-message: partially received message
::
+$  live-hear-message
  $:  num-received=fragment-num
      num-fragments=fragment-num
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
      live-messages=(map message-seq live-send-message)
      =pump-state
  ==
::  +live-send-message: state of a partially sent message
::
::    :error is a double unit:
::      ~           ::  we don't know whether the message succeeded or failed
::      [~ ~]       ::  we know the message succeeded
::      [~ ~ error] ::  we know the message failed
::
+$  live-send-message
  $:  error=(unit (unit error))
      route=path
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
  $:  $:  live-packets=@ud
          max-live-packets=@ud
          lost-packets=@ud
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
::  +message: application-level message
::
::    route: where in the recipient this message should go
::    payload: noun contents of message
::
+$  message  [route=path payload=*]
::  +packet: format of decoded packet  TODO better layer docs
::
+$  packet
  $%  ::  %back: acknowledgment of a received packet (positive or negative)
      ::
      ::    message-id: id of message containing acknowledged packet
      ::    ack-payload: body of data in acknowledgment
      ::
      [%back =message-id =ack-payload]
      ::  %bond: message fragment
      ::
      ::    message-id: pair of flow id (+bone) and message sequence number
      ::    fragment-num: index of packet within message
      ::    num-fragments: how many total fragments in this message
      ::    partial-message-blob: fragment of jammed message
      ::
      $:  %bond
          =message-id
          =fragment-num
          num-fragments=fragment-num
          =partial-message-blob
      ==
      ::  %fore: forwarded packet
      ::
      ::    ship: destination ship, to be forwarded to
      ::    lane: IP route, or null if unknown
      ::    raw-packet-blob: the wrapped packet, to be sent to :ship
      ::
      [%fore =ship lane=(unit lane) =raw-packet-blob]
  ==
::  +ack-payload: acknowledgment contents; partial or whole message
::
::    %fragment: ack a fragment within a message
::      fragment-num: which fragment is being acknowledged
::
::    %message: ack an entire message, positively or negatively
::      ok: did processing this message succeed? If no, this is a nack
::      lag: computation time, for help in congestion control
::
+$  ack-payload
  $%  [%fragment =fragment-num]
      [%message ok=? lag=@dr]
  ==
::  +pki-context: context for messaging between :our and peer
::  TODO: remove face from pki-info
::
+$  pki-context  [our=ship =our=life crypto-core=acru:ames her=ship =pki-info]
::  +pki-info: (possibly) secure channel between our and her
::
::    Everything we need to encode or decode a message between our and her.
::    :her-sponsors is the list of her current sponsors, not numeric ancestors.
::
::    TODO: we need a (unit deed) in here, or maybe even ours and hers 
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
::  +packet-format: packet contents to be jammed for sending
::
++  packet-format
  |%
  +$  none  raw-payload=packet
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
::  +lois: route; either galaxy or possibly indirect lane
::
::    Aspirational for now, but we hope to become agnostic to the
::    transport layer that the interpreter uses. Possibilities include
::    IPv4, IPv6, and I2P.
::
+$  lois                  (each @pD [direct=? lane=*])
::
+$  encoding              ?(%none %open %fast %full)
+$  error                 [tag=@tas =tang]
+$  fragment-index        [=message-seq =fragment-num]
+$  fragment-num          @udfragment
+$  key-hash              @uvH
+$  message-blob          @uwpacket  ::  XX  @uwmessage
+$  message-descriptor    [=message-id encoding-num=@ num-fragments=@]
+$  message-id            [=bone =message-seq]
+$  message-nonce         @uwmessagenonce
+$  message-seq           @udmessage
+$  packet-blob           @uwpacket
+$  partial-message-blob  @uwpartialmessage
+$  private-key           ring
+$  public-key            pass
+$  raw-packet            [[to=ship from=ship] =encoding =packet-blob]
+$  raw-packet-blob       @uwrawpacket
+$  raw-packet-hash       @uvH
+$  signature             @
+$  symmetric-key         @uvI
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
      %clue        (on-clue [ship pki-info]:task)
      %done        (on-done [ship bone error]:task)
      %hear        (on-hear [lane raw-packet-blob]:task)
      %mess        (on-mess [ship duct route payload]:task)
      %rend        (on-rend [ship bone route payload]:task)
      %wake        (on-wake error.task)
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
      =.  main-core
        (on-hear-from-peer peer-state i.inbound)
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
  ++  on-hear-from-peer
    |=  [=peer-state =lane =raw-packet]
    =/  peer-core  (per-peer-with-state from.raw-packet peer-state)
    ::
    abet:(hear:peer-core lane [encoding packet-blob]:raw-packet)
  ::
  ++  on-hear
    |=  [=lane =raw-packet-blob]
    ^+  main-core
    ::
    =/  =raw-packet  (decode-raw-packet raw-packet-blob)
    ?>  =(our to.raw-packet)
    =/  her=ship  from.raw-packet
    ::
    =/  ship-state  (~(get by peers.ames-state) her)
    ?:  ?=([~ %peer *] ship-state)
      %-  on-hear-from-peer
      :*  peer-state.u.ship-state
          lane
          raw-packet
      ==
    ::
    =/  =blocked-actions
      ?~  ship-state
        *blocked-actions
      blocked-actions.u.ship-state
    ::
    =.  inbound-packets.blocked-actions
      [[lane raw-packet] inbound-packets.blocked-actions]
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
          %heard-message  (heard-message [bone route payload]:gift)
          %meet           (give gift)
          %nacksplain     (nacksplain [message-id error]:gift)
          %ack-received   (to-task [bone %back error ~s0]:gift)
          %lane           peer-core(lane.peer-state `lane.gift)
          %send-ack       (send-ack [bone error]:gift)
          %symmetric-key  (handle-symmetric-key-gift symmetric-key.gift)
      ==
    ::  +nacksplain: send message explaining a nack
    ::
    ++  nacksplain
      |=  [[=bone =message-seq] =error]
      ^+  peer-core
      ::
      =.  main-core  (work [%rend her bone /a/nack message-seq error])
      peer-core
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
    ::  +heard-message: receive message; relay to client vane by bone parity
    ::
    ++  heard-message
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
          ^-  packet
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
            [%mess route=path payload=*]
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
      %mess  (handle-message-request [route payload]:task)
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
    |=  [=message-seq window-slots=@ud packets=(list raw-packet-descriptor)]
    ^+  [[remaining-slots=window-slots packets=packets] manager-core]
    ::
    =/  =live-send-message  (~(got by live-messages.outbound-state) message-seq)
    ::
    |-  ^+  [[window-slots packets] manager-core]
    ::  TODO document this condition
    ::
    ?:  |(=(0 window-slots) ?=(~ unsent-packets.live-send-message))
      =.  live-messages.outbound-state
        (~(put by live-messages.outbound-state) message-seq live-send-message)
      [[window-slots packets] manager-core]
    ::
    %_    $
        window-slots  (dec window-slots)
        packets       [i.unsent-packets.live-send-message packets]
        unsent-packets.live-send-message
      t.unsent-packets.live-send-message
    ==
  ::  +apply-packet-ack: possibly acks or nacks whole message
  ::
  ++  apply-packet-ack
    |=  [=fragment-index error=(unit error)]
    ^+  manager-core
    ::
    =/  live-send-message=(unit live-send-message)
      (~(get by live-messages.outbound-state) message-seq.fragment-index)
    ::  if we're already done with :live-send-message, no-op
    ::
    ?~  live-send-message                   manager-core
    ?~  unsent-packets.u.live-send-message  manager-core
    ::  if packet says message failed, save this nack and clear the message
    ::
    ?^  error
      =/  =message-seq  message-seq.fragment-index
      ~&  [%apply-packet-ack-fail message-seq]
      ::  finalize the message in :outbound-state, saving error
      ::
      =.  live-messages.outbound-state
        %+  ~(put by live-messages.outbound-state)  message-seq
        u.live-send-message(unsent-packets ~, error `error)
      ::  remove this message's packets from our packet pump queues
      ::
      =^  pump-gifts  pump-state.outbound-state
        (work:pump pump-ctx now %cull message-seq)
      ::
      (drain-pump-gifts pump-gifts)
    ::  sanity check: make sure we haven't acked more packets than exist
    ::
    ?>  (lth [acked-fragments total-fragments]:u.live-send-message)
    ::  apply the ack on this packet to our ack counter for this message
    ::
    =.  acked-fragments.u.live-send-message
      +(acked-fragments.u.live-send-message)
    ::  if final packet, we know no error ([~ ~]); otherwise, unknown (~)
    ::
    =.  error.u.live-send-message
      ?:  =(acked-fragments total-fragments):u.live-send-message
        [~ ~]
      ~
    ::  update :live-messages with modified :live-send-message
    ::
    =.  live-messages.outbound-state
      %+  ~(put by live-messages.outbound-state)
        message-seq.fragment-index
      u.live-send-message
    ::
    manager-core
  ::  +handle-message-request: break a message into packets, marking as unsent
  ::
  ++  handle-message-request
    |=  [route=path payload=*]
    ^+  manager-core
    ::  encode the message as packets, flipping bone parity
    ::
    =+  ^-  $:  meal-gifts=(list gift:encode-meal)
                fragments=(list partial-message-blob)
            ==
        ::
        %-  (encode-meal pki-context)
        :+  now  eny
        [%bond [(mix bone 1) next-tick.outbound-state] route payload]
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
      ^-  live-send-message
      ::
      :*  error=~
          route
          total-fragments=(lent fragments)
          acked-fragments=0
          ::
          ^=  unsent-packets  ^-  (list raw-packet-descriptor)
          =|  index=fragment-num
          |-  ^-  (list raw-packet-descriptor)
          ?~  fragments  ~
          ::
          :-  ^-  raw-packet-descriptor
              ::
              :^    virgin=&
                  [next-tick.outbound-state index]
                (shaf %flap i.fragments)
              `raw-packet-blob``@`i.fragments
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
::    Manages in-flight packets.
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
    %+  sub-safe  max-live-packets.metrics
    (add [live-packets lost-packets]:metrics)
  ::  +initialize-pump-metrics: make blank metrics from :now, stateless
  ::
  ++  initialize-pump-metrics
    |=  now=@da
    ^-  pump-metrics
    ::
    :*  :*  ^=  live-packets      0
            ^=  max-live-packets  2
            ^=  lost-packets      0
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
  ::          specifically, :lost-packets and :live-packets
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
    =.  live-packets.metrics.state.ctx  (dec live-packets.metrics.state.ctx)
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
    ?>  (lth [live-packets max-live-packets]:metrics)
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
    =.  live-packets.metrics.state.ctx  +(live-packets.metrics.state.ctx)
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
      live-packets.metrics.state   (dec live-packets.metrics.state)
      lost-packets.metrics.state   +(lost-packets.metrics.state)
    ==
  ::  +send-packets: resends lost packets then sends new until window closes
  ::
  ++  send-packets
    |=  [ctx=pump-context now=@da packets=(list raw-packet-descriptor)]
    ^-  pump-context
    =-  ~&  %send-packets^requested=(lent packets)^sent=(lent gifts.-)  -
    =.  ctx  (send-lost-packets ctx now)
    (send-new-packets ctx now packets)
  ::
  ::  +send-lost-packets: resend as many lost packets as possible
  ::
  ++  send-lost-packets
    =|  count=@ud
    |=  [ctx=pump-context now=@da]
    ^-  pump-context
    ?:  (gte count max-live-packets.metrics.state.ctx)
      ctx
    ?:  =(~ lost.state.ctx)
      ctx
    =^  lost-raw-packet  lost.state.ctx  ~(get to lost.state.ctx)
    =.  lost-packets.metrics.state.ctx  (dec lost-packets.metrics.state.ctx)
    ::
    =.  ctx  (fire-raw-packet ctx now lost-raw-packet)
    $(count +(count))
  ::
  ::  +send-new-packets: send the requested packets
  ::
  ++  send-new-packets
    |=  [ctx=pump-context now=@da packets=(list raw-packet-descriptor)]
    ^-  pump-context
    ?~  packets  ctx
    =.  ctx  (fire-raw-packet ctx now i.packets)
    $(packets t.packets)
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
::  +encode-message: generate raw packet blobs from a +message
::
++  encode-message
  |=  [pki-context fresh-fast-key=?]
  |=  [=message-id =message]
  ^-  (lest raw-packet-blob)
  ::  assert result contains at least one item
  ::
  =;  items  ?>(?=(^ items) items)
  ::
  ^-  (list raw-packet-blob)
  ::
  =/  =message-blob  (jam message)
  ::
  =/  fragments  (rip 13 message-blob)
  =/  num-fragments=fragment-num  (lent fragments)
  =/  index=fragment-num  0
  ::
  =/  packets
    |-  ^-  (list packet)
    ?~  fragments  ~
    ::
    :-  [%bond message-id index num-fragments i.fragments]
    ::
    $(fragments t.fragments, index +(index))
  ::  if symmetric key is new, send first packet as %full then rest as %fast
  ::
  ?:  fresh-fast-key
    ?>  ?=(^ packets)
    :-  ((encode-packet pki-context %full) i.packets)
    (turn t.packets (encode-packet pki-context %fast))
  ::  encrypt packets with symmetric key if we have one; else, just sign them
  ::
  %+  turn  packets
  %+  encode-packet  pki-context
  ?^(symmetric-key.pki-info %fast %open)
::  +encode-packet: encode a +packet into a +raw-packet-blob
::
::    Curried w.r.t. the context so assertions and lookups only need to
::    be performed once for a series of packets.
::
++  encode-packet
  |=  [pki-context =encoding]
  |=  =packet
  ^-  raw-packet-blob
  ::
  %-  encode-raw-packet
  ::
  ^-  raw-packet
  :+  [to=her from=our]  encoding
  ::
  ^-  packet-blob
  %-  jam
  ::
  ?-    encoding
  ::
  %fast
    ::
    ^-  fast:packet-format
    ::
    ?>  ?=(^ fast-key.pki-info)
    =/  =symmetric-key  symmetric-key.key.u.fast-key.pki-info
    =/  =key-hash       key-hash.u.fast-key.pki-info
    ::
    :-  key-hash
    (en:crub:crypto symmetric-key (jam packet))
  ::
  %full
    ::
    ^-  full:packet-format
    ::
    ?>  ?=(^ fast-key.pki-info)
    =/  her-public-key  (~(got by her-public-keys.pki-info) her-life.pki-info)
    =/  =symmetric-key  symmetric-key.key.u.fast-key.pki-info
    ::
    :+  [to=her-life.pki-info from=our-life]
      deed=~
    ::
    %+  seal:as:crypto-core
      her-public-key
    (jam [symmetric-key packet])
  ::
  %open
    ::
    ^-  open:packet-format
    ::
    :+  from=our-life  deed=~
    (sign:as:crypto-core (jam packet))
  ::
  %none
    ::
    ^-  none:packet-format
    ::
    packet
  ==
::  |message-decoder: decode and assemble input packets into messages
::
++  message-decoder
  =>  |%
      +$  gift
        $%  ::  %ack-received: we received an ack on a packet we sent
            ::
            [%ack-received =message-id =ack-payload]
            ::  %fore: forward packet TODO rename across file?
            ::
            [%fore =ship =lane =raw-packet-blob]
            ::  %heard-message: we received a full message
            ::
            [%heard-message =bone =message]
            ::  %lane: we learned a new route to :her
            ::
            [%lane =lane]
            ::  %meet: we learned someone's PKI information
            ::
            [%meet =ship =life =public-key]
            ::  %nacksplain: trigger nacksplanation message to be sent
            ::
            ::    message-id: id of message whose nack we're explaining
            ::    error: explanation of why the message failed
            ::
            [%nacksplain =message-id =error]
            ::  %send-ack: trigger ack to be sent
            ::
            [%send-ack =message-id =ack-payload]
            ::  %symmetric-key: we learned of a new symmetric key
            ::
            [%symmetric-key =symmetric-key]
        ==
      +$  task
        $%  ::  %done: handle ack from local client vane
            ::
            [%done =bone error=(unit error)]
            ::  %hear: handle packet from unix
            ::
            [%hear =lane =encoding =packet-blob]
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
    ^-  [[authenticated=? =packet] _decoder-core]
    ::
    =+  ^-  [gifts=(list gift:interpret-packet) authenticated=? =packet]
        ::
        %-  (interpret-packet her crypto-core pki-info)
        [encoding packet-blob]
    ::
    :-  [authenticated packet]
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
      ::
      =.  last-acked.inbound-state  +(last-acked.inbound-state)
      ::
      =^  top=[=message-seq =message]  pending-vane-ack.inbound-state
        ~(get to pending-vane-ack.inbound-state)
      ::
      =/  ok=?  =(~ error.task)
      ::
      =?  nacks.inbound-state  !ok
        (~(put in nacks.inbound-state) message-seq.top)
      ::
      =.  decoder-core
        (give %sack [bone message-seq.top] %message ok lag=`@dr`0)
      ::  TODO: send nacksplanation message here, or should |main do that?
      ::
      ?~  pending-vane-ack.inbound-state
        decoder-core
      (send-next-message-to-vane bone.task)
    ::
        %hear
      =^  decoded  decoder-core  (decode-packet [encoding packet-blob]:task)
      =+  [packet secure]=decoded
      ::  TODO document this effect
      ::
      =?  decoder-core  secure  (give %lane lane.task)
      ::
      ?-    -.packet
          %back
        ?.  secure
          ~|  %ames-insecure-ack-from^her  !!
        (give %rack [message-id fragment-num ok]:packet)
      ::
          %bond
        (on-hear-fragment secure +.packet)
      ::
          %fore
        =/  adjusted-lane=lane  (set-forward-origin lane lane.meal)
        (give %fore ship.meal adjusted-lane raw-packet-blob.meal)
      ==
    ==
  ::  +on-hear-fragment: handle a packet from a fragmented message
  ::
  ++  on-hear-fragment
    |=  $:  secure=?
            [=bone =message-seq]
            =fragment-num
            num-fragments=fragment-num
            =partial-message-blob
        ==
    ^+  decoder-core
    ::
    =/  =inbound-state
      %-  fall  :_  *inbound-state
      (~(get by bone-states) bone)
    ::  ignore messages too far in the future; limit to 10 messages in progress
    ::
    ?:  (gte message-seq (add 10 last-acked.inbound-state))
      decoder-core
    ::
    =/  is-last-fragment=?  =(+(fragment-num) num-fragments)
    ::  always ack a dupe! repeat a nack if they might not know about it
    ::
    ?:  (lte message-seq last-acked.inbound-state)
      ?.  is-last-fragment
        ::  single packet ack
        ::
        (give %sack [bone message-seq] %fragment fragment-num)
      ::  whole message ack or nack
      ::
      =/  ok=?  !(~(has in nacks.inbound-state) message-seq)
      (give %sack [bone message-seq] %message ok lag=`@dr`0)
    ::  last-acked<seq<=last-heard; we've heard message but not processed it
    ::
    ?:  (lte message-seq last-heard.inbound-state)
      ?:  is-last-fragment
        ::  last packet; drop, since we don't know whether to ack or nack yet
        ::
        decoder-core
      ::  ack all other packets
      ::
      (give %sack [bone message-seq] %fragment fragment-num)
    ::  last-heard<seq<10+last-heard; this is a packet in a live message
    ::
    =/  =live-hear-message
      ::  create a default :live-hear-message if this is the first fragment
      ::
      ?~  existing=(~(get by live-messages.inbound-state) message-seq)
        [num-received=0 num-fragments fragments=~]
      ::  we have an existing partial message; check parameters match
      ::
      ?>  (gth num-fragments.u.existing fragment-num)
      ?>  =(num-fragments.u.existing num-fragments)
      ::
      u.existing
    ::
    =/  already-heard=?  (~(has by fragments.live-hear-message) fragment-num)
    ::  always ack a dupe! ... or it's the last fragment in a message, drop it
    ::
    ?:  already-heard
      ?:  is-last-fragment
        decoder-core
      (give %sack [bone message-seq] %fragment fragment-num)
    ::  new fragment; register in our state and check if message is done
    ::
    =.  num-received.live-hear-message  +(num-received.live-hear-message)
    ::
    =.  fragments.live-hear-message
      %-  ~(put by fragments.live-hear-message)
      [fragment-num partial-message-blob]
    ::
    =.  live-messages.inbound-state
      %-  ~(put by live-messages.inbound-state)
      [message-seq live-hear-message]
    ::
    =.  bone-states  (~(put by bone-states) bone inbound-state)
    ::  ack any packet other than the last one, and continue either way
    ::
    =?  decoder-core  !is-last-fragment
      (give %sack [bone message-seq] %fragment fragment-num)
    ::  enqueue all completed messages starting at +(last-heard.inbound-state)
    ::
    |-  ^+  decoder-core
    ::  if this is not the next message to ack, we're done
    ::
    ?.  =(message-seq +(last-heard.inbound-state))
      decoder-core
    ::  if we haven't heard anything from this message, we're done
    ::
    ?~  live=(~(get by live-messages.inbound-state) message-seq)
      decoder-core
    ::  if the message isn't done yet, we're done
    ::
    ?.  =(num-received num-fragments):live
      decoder-core
    ::  we have the whole message; update state, assemble, and send to vane
    ::
    =.  last-heard.inbound-state  +(last-heard.inbound-state)
    ::
    =.  live-messages.inbound-state
      (~(del by live-messages.inbound-state) message-seq)
    ::
    =.  bone-states  (~(put by bone-states) bone inbound-state)
    ::  assemble and enqueue message to send to local vane for processing
    ::
    =/  =message      (assemble-fragments [num-fragments fragments]:live)
    =.  decoder-core  (enqueue-to-vane inbound-state bone message-seq message)
    ::
    $(message-seq +(message-seq))
  ::  +enqueue-to-vane: enqueue a completely heard message to be sent to vane
  ::
  ++  enqueue-to-vane
    |=  [=inbound-state =lane =bone =message-seq =message]
    ^+  decoder-core
    ::
    =/  empty=?  =(~ pending-vane-ack.inbound-state)
    ::
    =.  pending-vane-ack.inbound-state
      (~(put to pending-vane-ack.inbound-state) message-seq message)
    ::
    =.  bone-states  (~(put by bone-states) bone inbound-state)
    ::
    ?.  empty
      decoder-core
    (send-next-message-to-vane bone inbound-state lane message)
  ::  +send-next-message-to-vane: relay received message to local vane
  ::
  ::    Reads from persistent state and peeks at head of :pending-vane-ack
  ::    queue to figure out which message to send to the vane.
  ::
  ::    The vane will respond with an ack or nack when it's done processing
  ::    the message, at which point we'll pop this message off our queue and
  ::    send the next one.
  ::
  ++  send-next-message-to-vane
    |=  =bone
    ^+  decoder-core
    ::
    =/  =inbound-state  (~(got by bone-states) bone)
    =/  =message        message:~(top to pending-vane-ack.inbound-state)
    ::
    (give %have bone message)
  --
::  +assemble-fragments: produce a +message-blob by stitching fragments
::
++  assemble-fragments
  =|  index=fragment-num
  =|  sorted-fragments=(list partial-message-blob)
  ::
  |=  $:  num-fragments=fragment-num
          fragments=(map fragment-num partial-message-blob)
      ==
  ^-  message
  ::
  %-  message
  %-  cue
  ::
  |-  ^-  message-blob
  ::  final packet; concatenate fragment buffers
  ::
  ?:  =(num-fragments index)
    %+  can  13
    %+  turn  (flop sorted-fragments)
    |=(a=@ [1 a])
  ::  not the final packet; find fragment by index and prepend to list
  ::
  =/  current-fragment=partial-message-blob  (~(got by fragments) index)
  $(index +(index), sorted-fragments [current-fragment sorted-fragments])
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
  ^-  [gifts=(list gift) authenticated=? =packet]
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
    ^-  [gifts=(list gift) authenticated=? =packet]
    ::
    (produce-packet authenticated=%.n packet-blob)
  ::  +decode-open: decode a signed, unencrypted packet
  ::
  ++  decode-open
    ^-  [gifts=(list gift) authenticated=? =packet]
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
    %+  produce-packet  authenticated=%.y
    %-  need
    (extract-signed her-public-key signed-payload.open-packet)
  ::  +decode-fast: decode a packet with symmetric encryption
  ::
  ++  decode-fast
    ^-  [gifts=(list gift) authenticated=? =packet]
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
    %+  produce-packet  authenticated=%.y
    %-  need
    (de:crub:crypto symmetric-key.key.u.fast-key.pki-info payload)
  ::  +decode-full: decode a packet with asymmetric encryption
  ::
  ++  decode-full
    ^-  [gifts=(list gift) authenticated=? =packet]
    ::
    =/  packet-noun  (cue packet-blob)
    =/  full-packet  (full:packet-format packet-noun)
    ::
    =?    decoder-core
        ?=(^ deed.full-packet)
      (apply-deed u.deed.full-packet)
    ::  TODO: is this assertion valid if we hear a new deed?
    ::
    ?.  =(her-life.pki-info from-life.full-packet)
      ~|  [%ames-life-mismatch her her-life.pki-info from-life.full-packet]
      !!
    ::
    =/  her-public-key
      ~|  [%ames-pubkey-missing her her-life.pki-info from-life.full-packet]
      (~(got by her-public-keys.pki-info) her-life.pki-info)
    ::
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
    (produce-packet authenticated=%.y jammed-packet)
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
  ::  +produce-packet: exit with a +packet +cue'd from :packet-precursor
  ::
  ++  produce-packet
    |=  [authenticated=? packet-precursor=@]
    ^-  [gifts=(list gift) authenticated=? =packet]
    ::
    :+  (flop gifts)  authenticated
    %-  packet
    (cue packet-precursor)
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