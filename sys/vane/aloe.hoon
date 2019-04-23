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
        [%pass-message =ship =path message=*]
        ::  %forward-message: ask :ship to relay :message to another ship
        ::
        ::    This sends :ship a message that has been wrapped in an envelope
        ::    containing the address of the intended recipient.
        ::
        [%forward-message =ship =path message=*]
        ::  %hear: receive a packet from unix
        ::
        [%hear =lane packet=@]
        ::  %hole: receive notification from unix that packet crashed
        ::
        [%hole =lane packet=@]
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
        [%give-message message=*]
        ::  %send: tell unix to send a packet to another ship
        ::
        ::    Each %mess +task will cause one or more %send gifts to be
        ::    emitted to Unix, one per message fragment.
        ::
        [%send =lane packet=@]
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
          $%  ::  %pass-message: encode and send :message to :ship
              ::
              [%pass-message =ship =path message=*]
      ==  ==
      $:  %d
          $%  [%flog =flog:dill]
      ==  ==
      $:  %g
          $%  ::  %pass-message: encode and send :message to :ship
              ::
              [%pass-message =ship =path message=*]
      ==  ==
      $:  %j
          $%  ::  %pass-message: encode and send :message to :ship
              ::
              [%pass-message =ship =path message=*]
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
              [%give-message message=*]
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
              [%give-message message=*]
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
              [%give-message message=*]
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
      friends-blocked=(map ship blocked-channel)
      friends-open=(map ship friend-state)
  ==
+$  friend-state
  $:  =pipe
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
+$  blocked-channel
  $:  inbound-packets=(list [=lane packet=@])
      outbound-messages=(list [=duct route=path message=*])
  ==
+$  inbound-state
  $:  last-acked=message-seq
      partial-messages=(map message-seq partial-message)
      awaiting-application=(unit [=message-seq =packet-hash =lane])
      nacks=(map message-seq error)
  ==
+$  partial-message
  $:  =encoding
      num-received=@ud
      next-fragment=@ud
      fragments=(map @ud @)
  ==
::  +outbound-state: all data relevant to sending messages on a pipe
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
      unsent-packets=(list packet-descriptor)
  ==
::  +pump-state: all data relevant to a per-ship |packet-pump
::
::    Note that while :live and :lost are structurally normal queues,
::    we actually treat them as bespoke priority queues.
::
+$  pump-state
  $:  live=(qeu live-packet)
      lost=(qeu packet-descriptor)
      metrics=pump-metrics
  ==
::  +live-packet: data needed to track a packet in flight
::
::    Prepends :expiration-date and :sent-date to a +packet-descriptor.
::
+$  live-packet
  %-  expiring
  $:  sent-date=@da
      =packet-descriptor
  ==
::  +packet-descriptor: immutable data for an enqueued, possibly sent, packet
::
::    TODO: what is the virgin field?
::
+$  packet-descriptor
  $:  virgin=?
      =fragment-index
      =packet-hash
      payload=@
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
::  +pipe-context: context for messaging between :our and :her
::
+$  pipe-context  [our=ship =our=life crypto-core=acru:ames her=ship =pipe]
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
      [%back =bone =packet-hash error=(unit error) lag=@dr]
      ::  %bond: full message
      ::
      ::    message-id: pair of flow id and message sequence number
      ::    remote-route: intended recipient module on receiving ship
      ::    message: noun payload
      ::
      [%bond =message-id remote-route=path message=*]
      ::  %carp: message fragment
      ::
      ::    message-descriptor: message id and fragment count
      ::    fragment-num: which fragment is being sent
      ::    message-fragment: one slice of a message's bytestream
      ::
      [%carp =message-descriptor fragment-num=@ message-fragment=@]
      ::  %fore: forwarded packet
      ::
      ::    ship: destination ship, to be forwarded to
      ::    lane: IP route, or null if unknown
      ::    payload: the wrapped packet, to be sent to :ship
      ::
      [%fore =ship lane=(unit lane) payload=@]
  ==
::  +pipe: (possibly) secure channel between our and her
::
::    Everything we need to encode or decode a message between our and her.
::    :her-sponsors is the list of her current sponsors, not numeric ancestors.
::
::    TODO: do we need the map of her public keys, or just her current key?
::
+$  pipe
  $:  fast-key=(unit [=key-hash key=(expiring =symmetric-key)])
      her-life=(unit life)
      her-public-keys=(map life public-key)
      her-sponsors=(list ship)
  ==
::  +deed: identity attestation, typically signed by sponsor
::
+$  deed  (attested [=life =public-key =signature])
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
+$  symmetric-key       @uvI
+$  public-key          pass
+$  private-key         ring
+$  key-hash            @uvH
+$  signature           @
+$  message-descriptor  [=message-id encoding-num=@ num-fragments=@]
+$  message-id          [=bone =message-seq]
+$  message-seq         @ud
+$  fragment-num        @ud
+$  fragment-index      [=message-seq =fragment-num]
+$  packet-hash         @uvH
+$  error               [tag=@tas =tang]
+$  packet              [[to=ship from=ship] =encoding payload=@]
+$  encoding            ?(%none %open %fast %full)
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
        $%  [%east =duct =ship route=path message=*]
            [%home =lane packet=@]
            [%symmetric-key =ship (expiring =symmetric-key)]
            [%meet =ship =life =public-key]
            [%rest =duct error=(unit error)]
            [%send =lane packet=@]
            [%veil =ship]
            [%west =ship =bone route=path message=*]
        ==
      +$  task
        $%  [%clue =ship =pipe]
            [%done =ship =bone error=(unit error)]
            [%hear =lane packet=@]
            [%mess =ship =duct route=path message=*]
            [%rend =ship =bone route=path message=*]
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
  ++  work
    |=  =task
    ^+  main-core
    ::
    ?-  -.task
      %clue  (on-clue [ship pipe]:task)
      %done  (on-done [ship bone error]:task)
      %hear  (on-hear [lane packet]:task)
      %mess  (on-mess [ship duct route message]:task)
      %rend  (on-rend [ship bone route message]:task)
      %wake  (on-wake error.task)
    ==
  ::  +on-clue: neighbor update TODO docs and comments
  ::
  ++  on-clue
    |=  [=ship =pipe]
    ^+  main-core
    ::
    =/  blocked  (~(get by friends-blocked.ames-state) ship)
    ?~  blocked
      ::  we're not waiting for this ship; we must have it
      ::
      =.  friends-open.ames-state
        %+  ~(jab by friends-open.ames-state)  ship
        |=  =friend-state
        friend-state(pipe pipe)
      ::
      main-core
    ::  new neighbor; run all waiting i/o
    ::
    =/  =bone-manager  [next=2 by-duct=~ by-bone=~]
    =/  =friend-state  [pipe lane=~ bone-manager inbound=~ outbound=~]
    =.  friends-open.ames-state
      (~(put by friends-open.ames-state) ship friend-state)
    ::
    =/  inbound   (flop inbound-packets.u.blocked)
    ::
    =.  main-core
      |-  ^+  main-core
      ?~  inbound  main-core
      =.  main-core  (work [%hear i.inbound])
      $(inbound t.inbound)
    ::
    =/  outbound  (flop outbound-messages.u.blocked)
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
    abet:(done:(per-friend ship) bone error)
  ::
  ++  on-hear
    |=  [=lane raw-packet=@]
    ^+  main-core
    ::
    =/  decoded=packet  (decode-packet raw-packet)
    ?>  =(our to.decoded)
    =/  her=ship  from.decoded
    ::
    =/  neighbor-state  (~(get by friends-open.ames-state) her)
    ?~  neighbor-state
      =/  =blocked-channel
        %-  fall  :_  *blocked-channel
        (~(get by friends-blocked.ames-state) her)
      ::
      =.  inbound-packets.blocked-channel
        [[lane raw-packet] inbound-packets.blocked-channel]
      ::
      =.  main-core  (give %veil her)
      =.  friends-blocked.ames-state
        (~(put by friends-blocked.ames-state) her blocked-channel)
      ::
      main-core
    ::
    =/  friend-core   (per-friend-with-state her u.neighbor-state)
    =/  =packet-hash  (shaf %flap raw-packet)
    ::
    abet:(hear:friend-core lane packet-hash [encoding payload]:decoded)
  ::
  ++  on-mess
    |=  [her=ship =duct route=path message=*]
    ^+  main-core
    ::
    =/  neighbor-state  (~(get by friends-open.ames-state) her)
    ?~  neighbor-state
      =/  =blocked-channel
        %-  fall  :_  *blocked-channel
        (~(get by friends-blocked.ames-state) her)
      ::
      =.  outbound-messages.blocked-channel
        [[duct route message] outbound-messages.blocked-channel]
      ::
      =.  main-core  (give %veil her)
      =.  friends-blocked.ames-state
        (~(put by friends-blocked.ames-state) her blocked-channel)
      ::
      main-core
    ::
    =/  friend-core  (per-friend-with-state her u.neighbor-state)
    =^  bone  friend-core  (register-duct:friend-core duct)
    ::
    abet:(mess:friend-core bone route message)
  ::
  ++  on-rend
    |=  [=ship =bone route=path message=*]
    ^+  main-core
    ::
    abet:(mess:(per-friend ship) bone route message)
  ::
  ++  on-wake
    |=  error=(unit tang)
    ^+  main-core
    ::
    !!
  ::  +per-friend: convenience constructor for |friend-core
  ::
  ++  per-friend
    |=  her=ship
    =/  =friend-state  (~(got by friends-open.ames-state) her)
    (per-friend-with-state her friend-state)
  ::  +per-friend-with-state: full constructor for |friend-core
  ::
  ++  per-friend-with-state
    |=  [her=ship =friend-state]
    |%
    ++  friend-core  .
    ++  give  |=(=gift friend-core(main-core (^give gift)))
    ++  abet
      =.  friends-open.ames-state
        (~(put by friends-open.ames-state) her friend-state)
      main-core
    ::
    ++  done
      |=  [=bone error=(unit error)]
      ^+  friend-core
      ::
      (in-task %done bone error)
    ::
    ++  handle-decoder-gifts
      |=  gifts=(list gift:message-decoder)
      ^+  friend-core
      ::
      ?~  gifts  friend-core
      =.  friend-core  (handle-decoder-gift i.gifts)
      $(gifts t.gifts)
    ::
    ++  handle-decoder-gift
      |=  =gift:message-decoder
      ^+  friend-core
      ::
      ?-    -.gift
          %fore
        ?:  =(our ship.gift)
          (give %home [lane packet]:gift)
        (send(her ship.gift) [`lane packet]:gift)
      ::
          %have  (have [bone route message]:gift)
          %meet  (give gift)
          %rack  (to-task [bone %back packet-hash error ~s0]:gift)
          %rout  friend-core(lane.friend-state `lane.gift)
          %sack  (send-ack [bone packet-hash error]:gift)
          %symmetric-key  (handle-symmetric-key-gift symmetric-key.gift)
      ::
      ==
    ::
    ++  handle-encode-meal-gifts
      |=  gifts=(list gift:encode-meal)
      ^+  friend-core
      ::
      ?~  gifts  friend-core
      ::
      =.  friend-core
        ?>  ?=(%symmetric-key -.i.gifts)
        (give %symmetric-key her [expiration-date symmetric-key]:i.gifts)
      ::
      $(gifts t.gifts)
    ::
    ++  handle-message-manager-gifts
      |=  gifts=(list gift:message-manager)
      ^+  friend-core
      ::
      ?~  gifts  friend-core
      =.  friend-core  (handle-message-manager-gift i.gifts)
      $(gifts t.gifts)
    ::
    ++  handle-message-manager-gift
      |=  =gift:message-manager
      ^+  friend-core
      ::
      ?-  -.gift
          %mack
        =/  =duct  (~(got by by-bone.bone-manager.friend-state) bone.gift)
        (give %rest duct error.gift)
      ::
          %send  (send ~ payload.gift)
          %symmetric-key  (handle-symmetric-key-gift symmetric-key.gift)
      ==
    ::
    ++  handle-symmetric-key-gift
      |=  =symmetric-key
      ^+  friend-core
      ::
      (give %symmetric-key her (add ~m1 now) symmetric-key)
    ::  +have: receive message; relay to client vane by bone parity
    ::
    ++  have
      |=  [=bone route=path message=*]
      ^+  friend-core
      ::  even bone means backward flow, like a subscription update; always ack
      ::
      ?:  =(0 (end 0 1 bone))
        =/  =duct  (~(got by by-bone.bone-manager.friend-state) bone)
        ::
        =.  friend-core  (in-task %done bone ~)
        (give %east duct her route message)
      ::  odd bone, forward flow; wait for client vane to ack the message
      ::
      (give %west her bone route message)
    ::
    ++  hear
      |=  [=lane =packet-hash =encoding buffer=@]
      ^+  friend-core
      ::
      (in-task %hear lane packet-hash encoding buffer)
    ::
    ++  in-task
      |=  =task:message-decoder
      ^+  friend-core
      ::
      =/  decoder
        %-  message-decoder
        [her crypto-core.ames-state [pipe inbound]:friend-state]
      ::
      =^  gifts  inbound.friend-state  abet:(work:decoder task)
      (handle-decoder-gifts gifts)
    ::
    ++  make-message-manager
      |=  [=bone =outbound-state]
      %+  message-manager
        ^-  pipe-context
        [our life.ames-state crypto-core.ames-state her pipe.friend-state]
      [now eny bone outbound-state]
    ::
    ++  mess
      |=  [=bone route=path message=*]
      ^+  friend-core
      ::
      (to-task bone %mess route message)
    ::  +register-duct: add map between :duct and :next bone; increment :next
    ::
    ++  register-duct
      |=  =duct
      ^-  [bone _friend-core]
      ::
      =/  bone  (~(get by by-duct.bone-manager.friend-state) duct)
      ?^  bone
        [u.bone friend-core]
      ::
      =/  next=^bone  next.bone-manager.friend-state
      ::
      :-  next
      ::
      =.  bone-manager.friend-state
        :+  next=(add 2 next)
          by-duct=(~(put by by-duct.bone-manager.friend-state) duct next)
        by-bone=(~(put by by-bone.bone-manager.friend-state) next duct)
      ::
      friend-core
    ::  +send-ack: send acknowledgment
    ::
    ++  send-ack
      |=  [=bone =packet-hash error=(unit error)]
      ^+  friend-core
      ::
      =+  ^-  [gifts=(list gift:encode-meal) fragments=(list @)]
          ::
          %-  %-  encode-meal
              ^-  pipe-context
              :*  our
                  life.ames-state
                  crypto-core.ames-state
                  her
                  pipe.friend-state
              ==
          :+  now  eny
          ^-  meal
          [%back (mix bone 1) packet-hash error ~s0]
      ::
      =.  friend-core  (handle-encode-meal-gifts gifts)
      ::
      |-  ^+  friend-core
      ?~  fragments  friend-core
      =.  friend-core  (send ~ i.fragments)
      $(fragments t.fragments)
    ::  +send: send packet; TODO document :lane arg
    ::
    ++  send
      |=  [lane=(unit lane) packet=@]
      ^+  friend-core
      ::
      ?<  =(our her)
      =/  her-sponsors=(list ship)  her-sponsors.pipe.friend-state
      ::
      |-  ^+  friend-core
      ?~  her-sponsors  friend-core
      ::
      =/  new-lane=(unit ^lane)
        ?:  (lth i.her-sponsors 256)
          ::  galaxies are mapped into reserved IP space, which the interpreter
          ::  converts to a DNS request
          ::
          `[%if ~2000.1.1 31.337 (mix i.her-sponsors .0.0.1.0)]
        ::
        ?:  =(her i.her-sponsors)  lane.friend-state
        =/  neighbor-state  (~(get by friends-open.ames-state) i.her-sponsors)
        ?~  neighbor-state
          ~
        lane.u.neighbor-state
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
      =?  packet  |(!=(her i.her-sponsors) !=(~ lane))
        ::
        %-  encode-packet
        ^-  ^packet
        [[our i.her-sponsors] %none (jam `meal`[%fore her lane packet])]
      ::
      =.  friend-core  (give %send u.new-lane packet)
      ::  stop if we have an %if (direct) address;
      ::  continue if we only have %ix (forwarded).
      ::
      ?:  ?=(%if -.u.new-lane)
        friend-core
      $(her-sponsors t.her-sponsors)
    ::
    ++  to-task
      |=  [=bone =task:message-manager]
      ^+  friend-core
      ::
      =/  outbound  (~(get by outbound.friend-state) bone)
      =/  =outbound-state
        ?^  outbound  u.outbound
        =|  default=outbound-state
        default(metrics.pump-state (initialize-pump-metrics:pump now))
      ::
      =/  manager  (make-message-manager bone outbound-state)
      ::
      =^  gifts  outbound-state  abet:(work:manager task)
      (handle-message-manager-gifts gifts)
    --
  --
::  |message-manager: TODO docs
::
++  message-manager
  =>  |%
      +$  gift
        $%  ::  %symmetric-key: new fast key for pipe
            ::
            [%symmetric-key (expiring =symmetric-key)]
            ::  %mack: acknowledge a message
            ::
            [%mack =bone error=(unit error)]
            ::  %send: release a packet
            ::
            [%send =packet-hash payload=@]
        ==
      ::
      +$  task
        $%  ::  %back: process raw packet acknowledgment
            ::
            [%back =packet-hash error=(unit error) lag=@dr]
            ::  %mess: send a message
            ::
            [%mess remote-route=path message=*]
            ::  %wake: handle an elapsed timer
            ::
            [%wake ~]
        ==
      --
  |=  [pipe-context now=@da eny=@ =bone =outbound-state]
  =*  pipe-context  +<-
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
      %back  (handle-packet-ack [packet-hash error lag]:task)
      %mess  (handle-message-request [remote-route message]:task)
      %wake  wake
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
      %send  (give [%send packet-hash payload]:gift)
    ==
  ::  +handle-packet-ack: hear an ack; pass it to the pump
  ::
  ++  handle-packet-ack
    |=  [=packet-hash error=(unit error) lag=@dr]
    ^+  manager-core
    ::
    =^  pump-gifts  pump-state.outbound-state
      (work:pump pump-ctx now %back packet-hash error lag)
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
    =|  packets=(list packet-descriptor)
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
    |=  [index=@ud window-slots=@ud packets=(list packet-descriptor)]
    ^+  [[remaining-slots=window-slots packets=packets] manager-core]
    ::
    =/  message=live-message  (~(got by live-messages.outbound-state) index)
    ::
    |-  ^+  [[window-slots packets] manager-core]
    ::  TODO document this condition
    ::
    ?:  |(=(0 window-slots) ?=(~ unsent-packets.message))
      =.  live-messages.outbound-state
        (~(put by live-messages.outbound-state) index message)
      [[window-slots packets] manager-core]
    ::
    %_  $
      window-slots            (dec window-slots)
      packets                 [i.unsent-packets.message packets]
      unsent-packets.message  t.unsent-packets.message
    ==
  ::  +apply-packet-ack: possibly acks or nacks whole message
  ::
  ++  apply-packet-ack
    |=  [=fragment-index error=(unit error)]
    ^+  manager-core
    ::
    =/  message=(unit live-message)
      (~(get by live-messages.outbound-state) message-seq.fragment-index)
    ::  if we're already done with :message, no-op
    ::
    ?~  message                   manager-core
    ?~  unsent-packets.u.message  manager-core
    ::  if packet says message failed, save this nack and clear the message
    ::
    ?^  error
      =/  =message-seq  message-seq.fragment-index
      ~&  [%apply-packet-ack-fail message-seq]
      ::  finalize the message in :outbound-state, saving error
      ::
      =.  live-messages.outbound-state
        %+  ~(put by live-messages.outbound-state)  message-seq
        u.message(unsent-packets ~, error `error)
      ::  remove this message's packets from our packet pump queues
      ::
      =^  pump-gifts  pump-state.outbound-state
        (work:pump pump-ctx now %cull message-seq)
      ::
      (drain-pump-gifts pump-gifts)
    ::  sanity check: make sure we haven't acked more packets than exist
    ::
    ?>  (lth [acked-fragments total-fragments]:u.message)
    ::  apply the ack on this packet to our ack counter for this message
    ::
    =.  acked-fragments.u.message  +(acked-fragments.u.message)
    ::  if final packet, we know no error ([~ ~]); otherwise, unknown (~)
    ::
    =.  error.u.message
      ?:  =(acked-fragments total-fragments):u.message
        [~ ~]
      ~
    ::  update :live-messages with modified :message
    ::
    =.  live-messages.outbound-state
      %+  ~(put by live-messages.outbound-state)
        message-seq.fragment-index
      u.message
    ::
    manager-core
  ::  +handle-message-request: break a message into packets, marking as unsent
  ::
  ++  handle-message-request
    |=  [remote-route=path message=*]
    ^+  manager-core
    ::  encode the message as packets, flipping bone parity
    ::
    =+  ^-  [meal-gifts=(list gift:encode-meal) fragments=(list @)]
        ::
        %-  (encode-meal pipe-context)
        :+  now  eny
        [%bond [(mix bone 1) next-tick.outbound-state] remote-route message]
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
          ^=  unsent-packets  ^-  (list packet-descriptor)
          =/  index  0
          |-  ^-  (list packet-descriptor)
          ?~  fragments  ~
          ::
          :-  ^-  packet-descriptor
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
    ^+  manager-core
    ::
    =^  pump-gifts  pump-state.outbound-state
      (work:pump pump-ctx now %wake ~)
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
        $%  [%good =packet-hash =fragment-index rtt=@dr error=(unit error)]
            [%send =packet-hash =fragment-index payload=@]
            ::  TODO [%wait @da] to set timer
        ==
      ::  +task: request to the packet pump
      ::
      +$  task
        $%  ::  %back: raw acknowledgment
            ::
            ::    packet-hash: the hash of the packet we're acknowledging
            ::    error: non-null if negative acknowledgment (nack)
            ::    lag: self-reported computation lag, to be factored out of RTT
            ::
            [%back =packet-hash error=(unit error) lag=@dr]
            ::  %cull: cancel message
            ::
            [%cull =message-seq]
            ::  %pack: enqueue packets for sending
            ::
            [%pack packets=(list packet-descriptor)]
            ::  %wake: timer expired
            ::
            ::    TODO: revisit after timer refactor
            ::
            [%wake ~]
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
      %back  (back ctx now [packet-hash error lag]:task)
      %cull  [gifts.ctx (cull state.ctx message-seq.task)]
      %pack  (send-packets ctx now packets.task)
      %wake  [gifts.ctx (wake state.ctx now)]
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
    =/  next=(unit live-packet)  ~(top to live.state)
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
    |=  [ctx=pump-context now=@da =packet-hash error=(unit error) lag=@dr]
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
        (done ctx ack packet-hash error rtt)
    ::  liv: iteratee starting as :live.state.ctx
    ::
    =/  liv=(qeu live-packet)  live.state.ctx
    ::  main loop
    ::
    |-  ^-  $:  ack=(unit live-packet)
                ded=(list live-packet)
                lov=(qeu live-packet)
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
                ack=(unit live-packet)
                ded=(list live-packet)
                lov=(qeu live-packet)
            ==
        ?:  =(packet-hash packet-hash.packet-descriptor.n.liv)
          [| `n.liv ~ l.liv]
        [& $(liv l.liv)]
    ::
    ?~  ack  [~ ~ liv]
    ::
    =*  virgin  virgin.packet-descriptor.u.ack
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
      ?.  =(message-seq message-seq.fragment-index.packet-descriptor.n.liv)
        vil
      ~(nip to `(qeu live-packet)`vil)
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
      ~(nip to `(qeu packet-descriptor)`pol)
    ::
    state
  ::  +done: process a cooked ack; may emit a %good ack gift
  ::
  ++  done
    |=  $:  ctx=pump-context
            live-packet=(unit live-packet)
            =packet-hash
            error=(unit error)
            rtt=@dr
        ==
    ^-  pump-context
    ?~  live-packet  ctx
    ::
    =*  fragment-index  fragment-index.packet-descriptor.u.live-packet
    =.  ctx  (give ctx [%good packet-hash fragment-index rtt error])
    ::
    =.  window-length.metrics.state.ctx  (dec window-length.metrics.state.ctx)
    ::
    ctx
  ::  +enqueue-lost-packet: ordered enqueue into :lost.pump-state
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
  ::      - packet-hash
  ::
  ::    TODO: why do we need the packet-hash tiebreaker?
  ::    TODO: write queue order function
  ::
  ++  enqueue-lost-packet
    |=  [state=pump-state pac=packet-descriptor]
    ^+  lost.state
    ::
    =/  lop  lost.state
    ::
    |-  ^+  lost.state
    ?~  lop  [pac ~ ~]
    ::
    ?:  ?|  (older fragment-index.pac fragment-index.n.lop)
            ?&  =(fragment-index.pac fragment-index.n.lop)
                (lth packet-hash.pac packet-hash.n.lop)
        ==  ==
      lop(r $(lop r.lop))
    lop(l $(lop l.lop))
  ::  +fire-packet: emit a %send gift for a packet and do bookkeeping
  ::
  ++  fire-packet
    |=  [ctx=pump-context now=@da pac=packet-descriptor]
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
      ^-  live-packet
      :+  last-deadline.metrics.state.ctx
        last-sent.metrics.state.ctx
      pac
    ::  emit the packet
    ::
    (give ctx [%send packet-hash fragment-index payload]:pac)
  ::  +lose: abandon packets
  ::
  ++  lose
    |=  [state=pump-state packets=(list live-packet)]
    ^-  pump-state
    ?~  packets  state
    ::
    =.  lost.state  (enqueue-lost-packet state packet-descriptor.i.packets)
    ::
    %=  $
      packets                      t.packets
      window-length.metrics.state  (dec window-length.metrics.state)
      retry-length.metrics.state   +(retry-length.metrics.state)
    ==
  ::  +send-packets: resends lost packets then sends new until window closes
  ::
  ++  send-packets
    |=  [ctx=pump-context now=@da packets=(list packet-descriptor)]
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
      =^  lost-packet  lost.state.ctx  ~(get to lost.state.ctx)
      =.  retry-length.metrics.state.ctx  (dec retry-length.metrics.state.ctx)
      ::
      =.  ctx  (fire-packet ctx now lost-packet)
      $(slots (dec slots))
    ::  now that we've finished the backlog, send the requested packets
    ::
    =.  ctx  (fire-packet ctx now i.packets)
    $(packets t.packets, slots (dec slots))
  ::  +wake: handle elapsed timer
  ::
  ++  wake
    |=  [state=pump-state now=@da]
    ^-  pump-state
    ::
    =-  =.  live.state  live.-
        (lose state dead.-)
    ::
    ^-  [dead=(list live-packet) live=(qeu live-packet)]
    ::
    =|  dead=(list live-packet)
    =/  live=(qeu live-packet)  live.state
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
  |=  pipe-context
  ::  inner gate: process a meal, producing side effects and packets
  ::
  |=  [now=@da eny=@ =meal]
  ::
  |^  ^-  [gifts=(list gift) fragments=(list @)]
      ::
      =+  ^-  [gifts=(list gift) =encoding message=@]  generate-message
      ::
      [gifts (generate-fragments encoding message)]
  ::  +generate-fragments: split a message into packets
  ::
  ++  generate-fragments
    |=  [=encoding message=@]
    ^-  (list @)
    ::  total-packets: number of packets for message
    ::
    ::    Each packet has max 2^13 bits so it fits in the MTU on most systems.
    ::
    =/  total-fragments=@ud  (met 13 message)
    ::  if message fits in one packet, don't fragment
    ::
    ?:  =(1 total-fragments)
      [(encode-packet [our her] encoding message) ~]
    ::  fragments: fragments generated from splitting message
    ::
    =/  fragments=(list @)  (rip 13 message)
    =/  fragment-index=@ud  0
    ::  wrap each fragment in a %none encoding of a %carp meal
    ::
    |-  ^-  (list @)
    ?~  fragments  ~
    ::
    :-  ^-  @
        %^  encode-packet  [our her]  %none
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
    ^-  [gifts=(list gift) =encoding payload=@]
    ::  if :meal is just a single fragment, don't bother double-encrypting it
    ::
    ?:  =(%carp -.meal)
      [gifts=~ encoding=%none payload=(jam meal)]
    ::  if this channel has a symmetric key, use it to encrypt
    ::
    ?^  fast-key.pipe
      :-  ~
      :-  %fast
      %^  cat  7
        key-hash.u.fast-key.pipe
      (en:crub:crypto symmetric-key.key.u.fast-key.pipe (jam meal))
    ::  if we don't know their life, just sign this packet without encryption
    ::
    ?~  her-life.pipe
      :-  ~
      :-  %open
      %-  jam
      ^-  open:packet-format
      :+  our-life
        deed=~
      (sign:as:crypto-core (jam meal))
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
    :+  [to=u.her-life.pipe from=our-life]  deed=~
    ::  encrypt the pair of [new-symmetric-key (jammed-meal)] for her eyes only
    ::
    ::    This sends the new symmetric key by piggy-backing it onto the
    ::    original message.
    ::
    %+  seal:as:crypto-core
      (~(got by her-public-keys.pipe) u.her-life.pipe)
    (jam [new-symmetric-key (jam meal)])
  --
::  |message-decoder: decode and assemble input packets into messages
::
::    TODO: document
::
++  message-decoder
  =>  |%
      +$  gift
        $%  [%fore =ship =lane packet=@]
            [%have =bone route=path message=*]
            [%symmetric-key =symmetric-key]
            [%meet =ship =life =public-key]
            [%rack =bone =packet-hash error=(unit error)]
            [%rout =lane]
            [%sack =bone =packet-hash error=(unit error)]
        ==
      +$  task
        $%  [%done =bone error=(unit error)]
            [%hear =lane =packet-hash =encoding packet=@]
        ==
      --
  ::
  =|  gifts=(list gift)
  ::
  |=  $:  her=ship
          crypto-core=acru:ames
          =pipe
          bone-states=(map bone inbound-state)
      ==
  |%
  ++  decoder-core  .
  ++  abet  [(flop gifts) bone-states]
  ++  give  |=(=gift decoder-core(gifts [gift gifts]))
  ::
  ++  decode-packet
    |=  [=encoding packet=@]
    ^-  [[authenticated=? =meal] _decoder-core]
    ::
    =+  ^-  [gifts=(list gift:interpret-packet) authenticated=? =meal]
        ::
        %-  (interpret-packet her crypto-core pipe)
        [encoding packet]
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
          packet-hash.to-apply
          lane.to-apply
          inbound-state
        ==
      ::
      abet:(on-message-completed:assembler error.task)
    ::
        %hear
      =^  decoded  decoder-core  (decode-packet [encoding packet]:task)
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
        (give %rack [bone packet-hash error]:meal)
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
            packet-hash.task
            lane.task
            inbound-state
          ==
        ::
        abet:(on-bond:assembler [remote-route message]:meal)
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
            packet-hash.task
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
            message-fragment.meal
        ==
      ::
          ::  %fore: we heard a packet to forward; convert origin and pass it on
          ::
          %fore
        =/  =lane  (set-forward-origin lane.task lane.meal)
        (give %fore ship.meal lane payload.meal)
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
            =packet-hash
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
      (give %sack bone packet-hash error)
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
      |=  [route=path message=*]
      ^+  assembler-core
      ::  if we already acked this message, ack it again
      ::  if later than next expected message or already being processed, ignore
      ::
      ?:  (lth message-seq last-acked.inbound-state)  give-duplicate-ack
      ?:  (gth message-seq last-acked.inbound-state)  assembler-core
      ?.  =(~ awaiting-application.inbound-state)     assembler-core
      ::  record message as in-process and delete partial message
      ::
      =.  awaiting-application.inbound-state  `[message-seq packet-hash lane]
      =.  partial-messages.inbound-state
        (~(del by partial-messages.inbound-state) message-seq)
      ::
      (give [%have bone route message])
    ::  +on-carp: add a fragment to a partial message, possibly completing it
    ::
    ++  on-carp
      |=  [=encoding count=@ud fragment-num=@ud fragment=@]
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
        (~(put by fragments.partial-message) fragment-num fragment)
      ::  if we haven't received all fragments, update state and ack packet
      ::
      ?.  =(num-received next-fragment):partial-message
        =.  fragments.partial-message
          (~(put by fragments.partial-message) message-seq fragment)
        ::
        (give-ack ~)
      ::  assemble and decode complete message
      ::
      =/  message-buffer=@
        (assemble-fragments [next-fragment fragments]:partial-message)
      ::
      =^  decoded  decoder-core  (decode-packet encoding message-buffer)
      ::
      =.  authenticated  |(authenticated authenticated.decoded)
      =*  meal  meal.decoded
      ::
      ?-    -.meal
          %back
        ~|  %ames-back-insecure-from^her
        ?>  authenticated
        (give %rack bone [packet-hash error]:meal.decoded)
      ::
          %bond
        ~|  %ames-message-assembly-failed
        ?>  &(authenticated =([bone message-seq] message-id.meal))
        ::
        (on-bond [remote-route message]:meal)
      ::
          %carp  ~|(%ames-meta-carp !!)
          %fore
        =/  adjusted-lane=^lane  (set-forward-origin lane lane.meal)
        (give %fore ship.meal adjusted-lane payload.meal)
      ==
    ::
    ++  assemble-fragments
      =|  index=@
      =|  sorted-fragments=(list @)
      ::
      |=  [next-fragment=@ud fragments=(map @ud @)]
      ^-  @
      ::  final packet; concatenate fragment buffers
      ::
      ?:  =(next-fragment index)
        %+  can  13
        %+  turn  (flop sorted-fragments)
        |=(a=@ [1 a])
      ::  not the final packet; find fragment by index and prepend to list
      ::
      =/  current-fragment=@  (~(got by fragments) index)
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
  ::    pipe:            channel between our and her
  ::
  |=  $:  her=ship
          crypto-core=acru:ames
          =pipe
      ==
  ::  inner gate: decode a packet
  ::
  |=  [=encoding buffer=@]
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
    (produce-meal authenticated=%.n buffer)
  ::  +decode-open: decode a signed, unencrypted packet
  ::
  ++  decode-open
    ^-  [gifts=(list gift) authenticated=? =meal]
    ::
    =/  packet-noun  (cue buffer)
    =/  open-packet  (open:packet-format packet-noun)
    ::
    =?    decoder-core
        ?=(^ deed.open-packet)
      (apply-deed u.deed.open-packet)
    ::  TODO: is this assertion at all correct?
    ::  TODO: make sure the deed gets applied to the pipe if needed
    ::
    ?>  =((need her-life.pipe) from-life.open-packet)
    ::
    =/  her-public-key  (~(got by her-public-keys.pipe) (need her-life.pipe))
    ::
    %+  produce-meal  authenticated=%.y
    %-  need
    (extract-signed her-public-key signed-payload.open-packet)
  ::  +decode-fast: decode a packet with symmetric encryption
  ::
  ++  decode-fast
    ^-  [gifts=(list gift) authenticated=? =meal]
    ::
    ?~  fast-key.pipe
      ~|  %ames-no-fast-key^her  !!
    ::
    =/  key-hash=@   (end 7 1 buffer)
    =/  payload=@    (rsh 7 1 buffer)
    ::
    ~|  [%ames-bad-fast-key `@ux`key-hash `@ux`key-hash.u.fast-key.pipe]
    ?>  =(key-hash key-hash.u.fast-key.pipe)
    ::
    %+  produce-meal  authenticated=%.y
    %-  need
    (de:crub:crypto symmetric-key.key.u.fast-key.pipe payload)
  ::  +decode-full: decode a packet with asymmetric encryption
  ::
  ++  decode-full
    ^-  [gifts=(list gift) authenticated=? =meal]
    ::
    =/  packet-noun  (cue buffer)
    =/  full-packet  (full:packet-format packet-noun)
    ::
    =?    decoder-core
        ?=(^ deed.full-packet)
      (apply-deed u.deed.full-packet)
    ::  TODO: is this assertion valid if we hear a new deed?
    ::
    ~|  [%ames-life-mismatch her her-life.pipe from-life.full-packet]
    ?>  =((need her-life.pipe) from-life.full-packet)
    ::
    =/  her-public-key  (~(got by her-public-keys.pipe) (need her-life.pipe))
    =/  jammed-wrapped=@
      %-  need
      (tear:as:crypto-core her-public-key encrypted-payload.full-packet)
    ::
    =+  %-  ,[=symmetric-key jammed-message=@]
        (cue jammed-wrapped)
    ::
    =.  decoder-core  (give %symmetric-key symmetric-key)
    =.  decoder-core  (give %meet her (need her-life.pipe) her-public-key)
    ::
    (produce-meal authenticated=%.y jammed-message)
  ::  +apply-deed: produce a %meet gift if the deed checks out
  ::
  ++  apply-deed
    |=  =deed
    ^+  decoder-core
    ::
    =+  [expiration-date life public-key signature]=deed
    ::  if we already know the public key for this life, noop
    ::
    ?:  =(`public-key (~(get by her-public-keys.pipe) life))
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
::  +decode-packet: deserialize a packet from a bytestream, reading the header
::
++  decode-packet
  |=  buffer=@uvO
  ^-  packet
  ::  first 32 (2^5) bits are header; the rest is body
  ::
  =/  header  (end 5 1 buffer)
  =/  body    (rsh 5 1 buffer)
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
  payload=(rsh 3 (add receiver-width sender-width) body)
::  +encode-packet: serialize a packet into a bytestream
::
++  encode-packet
  |=  =packet
  ^-  @uvO
  ::
  =/  receiver-type   (encode-ship-type to.packet)
  =/  receiver-width  (bex +(receiver-type))
  ::
  =/  sender-type   (encode-ship-type from.packet)
  =/  sender-width  (bex +(sender-type))
  ::  body: <<receiver sender payload>>
  ::
  =/  body
    ;:  mix
      to.packet
      (lsh 3 receiver-width from.packet)
      (lsh 3 (add receiver-width sender-width) payload.packet)
    ==
  ::
  =/  encoding-number  (encoding-to-number encoding.packet)
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
