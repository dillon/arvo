!:  ::  %gall, agent execution
!?  163
::::
|=  pit=vase
=,  gall
=>  =~
::
::  (rest of arvo)
::
|%
::
::  +internal-gift: synonym for +cuft.
::
++  internal-gift  cuft
::
::  +internal-task: synonym for +cush.
::
++  internal-task  cush
::
::  +agent-action: synonym for +club.
::
++  agent-action  club
::
::  +coke: cook.
::
++  coke
  $?  %inn
      %out
      %cay
  ==
::
::  +volt: voltage.
::
++  volt  ?(%low %high)
::
::  +security-control: security control.
::
++  security-control  $@(?(%iron %gold) [%lead p=ship])
::
::  +reverse-ames: reverse ames message.
::
++  reverse-ames
  $%
      :: diff
      ::
      [action=%d p=mark q=*]
      ::  etc.
      ::
      [action=%x ~]
  ==
::
::  +forward-ames: forward ames message.
::
++  forward-ames
  $%
      :: message
      ::
      [action=%m mark=mark noun=*]
      :: "peel" subscribe
      ::
      [action=%l mark=mark path=path]
      :: subscribe
      ::
      [action=%s path=path]
      :: cancel+unsubscribe
      ::
      [action=%u ~]
  ==
::
::  +foreign-response: foreign response.
::
++  foreign-response
  $?  %peer
      %peel
      %poke
      %pull
  ==
--
::
::  (local arvo)
::
|%
::
::  +internal-note: +ap note.
::
++  internal-note
  $%  [task=%meta =term =vase]
      [task=%send =ship =internal-task]
      [task=%hiss knot=(unit knot) =mark =cage]
  ==
::
::  +internal-move: internal move.
::
++  internal-move
  $:
    =bone
    move=(wind internal-note internal-gift)
  ==
::
::  +move: typed move.
::
++  move  (pair duct (wind note-arvo gift-arvo))
--
::
::  (%gall state)
::
|%
::
::  +gall-n: upgrade path.
::
++  gall-n  ?(gall)
::
::  +gall: all state.
::
++  gall
  $:
      :: state version
      ::
      %0
      :: apps by ship
      ::
      =ship-state
  ==
::
::  +subscriber-data: subscriber data.
::
++  subscriber-data
  $:
      :: incoming subscribers
      ::
      incoming=bitt
      :: outgoing subscribers
      ::
      outgoing=boat
      :: queue meter
      ::
      meter=(map bone @ud)
  ==
::
::  +ship-state: ship state.
::
++  ship-state
  $:
      :: (deprecated)
      ::
      mak=*
      ::  system duct
      ::
      system-duct=duct
      ::  foreign contacts
      ::
      contacts=(map ship foreign)
      ::  running agents
      ::
      running=(map dude agent)
      ::  waiting queue
      ::
      waiting=(map dude blocked)
  ==
::
::  +routes: new cuff.
::
++  routes
    $:
        :: disclosing to
        ::
        disclosing=(unit (set ship))
        :: attributed to
        ::
        attributing=ship
    ==
::
::  +privilege: privilege.
::
++  privilege
    $:
        :: voltage
        ::
        =volt
        :: routes
        ::
        =routes
    ==
::
::  +foreign: foreign connections.
::
++  foreign
  $:
      :: index
      ::
      index=@ud
      :: by duct
      ::
      index-map=(map duct @ud)
      :: by index
      ::
      duct-map=(map @ud duct)
  ==
::
::  +opaque-ducts: opaque input.
::
++  opaque-ducts
  $:
      :: bone sequence
      ::
      bone=@ud
      :: by duct
      ::
      bone-map=(map duct bone)
      :: by bone
      ::
      duct-map=(map bone duct)
  ==
::
::  +misvale-data: subscribers with bad marks.
::
::    XX a hack, required to break a subscription loop
::    which arises when an invalid mark crashes a diff.
::    See usage in ap-misvale.
::
++  misvale-data  (set wire)
::
::  +agent: agent state.
::
++  agent
  $:
      :: bad reqs
      ::
      misvale=misvale-data
      :: cache
      ::
      cache=worm
      :: ap-find cache
      ::
      find-cache=(map [term path] (unit (pair @ud term)))
      :: control duct
      ::
      control-duct=duct
      :: unstopped
      ::
      live=?
      :: privilege
      ::
      privilege=security-control
      :: statistics
      ::
      stats=stats
      :: subscribers
      ::
      subscribers=subscriber-data
      :: running state
      ::
      running-state=vase
      :: update control
      ::
      beak=beak
      :: req'd translations
      ::
      required-trans=(map bone mark)
      :: opaque ducts
      ::
      ducts=opaque-ducts
  ==
::
:: +blocked: blocked kisses.
::
++  blocked  (qeu (trel duct privilege agent-action))
::
:: +stats: statistics.
::
++  stats
  $:
      :: change number
      ::
      change=@ud
      :: entropy
      ::
      eny=@uvJ
      :: time
      ::
      time=@da
  ==
--
::
:: (vane header)
::
.  ==
::
:: (all vane state)
::
=|  =gall
|=  $:
        :: identity
        ::
        our=ship
        :: urban time
        ::
        now=@da
        :: entropy
        ::
        eny=@uvJ
        :: activate
        ::
        ska=sley
    ==
::
::  (opaque core)
::
~%  %gall-top  ..is  ~
::
::  (state machine)
::
|%
::
::  +gall-payload:  gall payload.
::
++  gall-payload  +
::
::  +mo: move handling.
::
++  mo
  ~%  %gall-mo  +>  ~
  ::
  |_
    $:
      hen=duct
      moves=(list move)
    ==
  ::
  ++  mo-state  .
  ::
  ::  +mo-abed: initialise engine with the provided duct.
  ::
  ++  mo-abed
    |=  =duct
    ^+  mo-state
    ::
    mo-state(hen duct)
  ::
  ::  +mo-abet: resolve moves.
  ::
  ++  mo-abet
    ^-  [(list move) _gall-payload]
    ::
    =/  resolved  (flop moves)
    [resolved gall-payload]
  ::
  ::  +mo-boot: pass a %build move to ford.
  ::
  ++  mo-boot
    |=  [=dude =ship =desk]
    ^+  mo-state
    ::
    =/  =case  [%da now]
    ::
    =/  =path
      =/  ship  (scot %p ship)
      =/  case  (scot case)
      /sys/core/[dude]/[ship]/[desk]/[case]
    ::
    =/  =note-arvo
      =/  disc  [ship desk]
      =/  spur  /hoon/[dude]/app
      =/  schematic  [%core disc spur]
      [%f %build live=%.y schematic]
    ::
    =/  pass  [path note-arvo]
    (mo-pass pass)
  ::
  ::  +mo-pass: prepend a standard %pass move to the move state.
  ::
  ++  mo-pass
    |=  pass=(pair path note-arvo)
    ^+  mo-state
    ::
    =/  =move  [hen [%pass pass]]
    mo-state(moves [move moves])
  ::
  ::  +mo-give: prepend a standard %give move to the move state.
  ::
  ++  mo-give
    |=  =gift:able
    ^+  mo-state
    ::
    =/  =move  [hen [%give gift]]
    mo-state(moves [move moves])
  ::
  :: +mo-okay: check that a vase contains a valid bowl.
  ::
  ++  mo-okay
    ~/  %mo-okay
    |=  =vase
    ^-  ?
    ::
    ::  inferred type of default bowl
    =/  bowl-type  -:!>(*bowl)
    ::
    =/  maybe-vase  (slew 12 vase)
    ?~  maybe-vase
      %.n
    ::
    =/  =type  p.u.maybe-vase
    (~(nest ut type) %.n bowl-type)
  ::
  ::  +mo-receive-core: receives an app core built by ford.
  ::
  ++  mo-receive-core
    ~/  %mo-receive-core
    |=  [=dude =beak =made-result:ford]
    ^+  mo-state
    ::
    ?:  ?=([%incomplete *] made-result)
      (mo-give %onto %.n tang.made-result)
    ::
    =/  build-result  build-result.made-result
    ::
    ?:  ?=([%error *] build-result)
      (mo-give %onto %.n message.build-result)
    ::
    =/  =cage  (result-to-cage:ford build-result)
    =/  result-vase  q.cage
    ::
    =/  app-data=(unit agent)
      (~(get by running.ship-state.gall) dude)
    ::
    ?^  app-data
      ::  update the path
      ::
      =/  updated  u.app-data(beak beak)
      ::
      =.  running.ship-state.gall
        (~(put by running.ship-state.gall) dude updated)
      ::
      ::  magic update string from the old +mo-boon, "complete old boot"
      ::
      =/  =privilege
        =/  =routes  [disclosing=~ attributing=our]
        [%high routes]
      ::
      =/  initialised  (ap-abed:ap dude privilege)
      =/  peeped  (ap-peep:initialised result-vase)
      ap-abet:peeped
    ::  first install of the app
    ::
    ?.  (mo-okay result-vase)
      =/  err  [[%leaf "{<dude>}: bogus core"] ~]
      (mo-give %onto %.n err)
    ::
    =.  mo-state  (mo-born dude beak result-vase)
    ::
    =/  old  mo-state
    ::
    =/  wag
      =/  =routes  [disclosing=~ attributing=our]
      =/  =privilege  [%high routes]
      =/  initialised  (ap-abed:ap dude privilege)
      (ap-prop:initialised ~)
    ::
    =/  maybe-tang  -.wag
    =/  new  +.wag
    ::
    ?^  maybe-tang
      =.  mo-state  old
      (mo-give %onto %.n u.maybe-tang)
    ::
    =.  mo-state  ap-abet:new
    ::
    =/  clawed  (mo-claw dude)
    (mo-give:clawed %onto %.y dude %boot now)
  ::
  ::  +mo-born: create a new agent.
  ::
  ++  mo-born
    |=  [=dude =beak =vase]
    ^+  mo-state
    ::
    =/  =opaque-ducts
      :+  bone=1
        bone-map=[[[~ ~] 0] ~ ~]
       duct-map=[[0 [~ ~]] ~ ~]
    ::
    =/  agent
      =/  default-agent  *agent
      %_  default-agent
        control-duct    hen
        beak            beak
        running-state   vase
        ducts           opaque-ducts
      ==
    ::
    =/  agents
      (~(put by running.ship-state.gall) dude agent)
    ::
    %_  mo-state
      running.ship-state.gall  agents
    ==
  ::
  :: +mo-away: handle a foreign request.
  ::
  ++  mo-away
    ~/  %mo-away
    |=  [=ship =internal-task]
    ^+  mo-state
    ::
    =/  =dude  p.internal-task
    =/  =agent-action  q.internal-task
    ::
    ?:  ?=(%pump -.agent-action)
      ::
      ::  you'd think this would send an ack for the diff
      ::  that caused this pump.  it would, but we already
      ::  sent it when we got the diff in ++mo-cyst.  then
      ::  we'd have to save the network duct and connect it
      ::  to this returning pump.
      ::
      mo-state
    ::
    ?:  ?=(%peer-not -.agent-action)
      =/  =tang  p.agent-action
      (mo-give %unto %reap (some tang))
    ::
    =^  bone  mo-state  (mo-bale ship)
    ::
    =/  =forward-ames
      ?-  -.agent-action
        %poke  [%m p.p.agent-action q.q.p.agent-action]
        %pull  [%u ~]
        %puff  !!
        %punk  !!
        %peel  [%l agent-action]
        %peer  [%s p.agent-action]
      ==
    ::
    =/  sys-path
      =/  action  -.agent-action
      /sys/way/[action]
    ::
    =/  =note-arvo
      =/  =path  [%g %ge dude ~]
      =/  noun  [bone forward-ames]
      [%a %want ship path noun]
    ::
    (mo-pass sys-path note-arvo)
  ::
  ::  +mo-awed: handle foreign response.
  ::
  ++  mo-awed
    |=  [=foreign-response art=(unit ares)]
    ^+  mo-state
    ::
    =/  =ares
      =/  tanks  [%blank ~]
      =/  tang  (some tanks)
      (fall art tang)
    ::
    =/  to-tang
      |=  ars=(pair term tang)
      ^-  tang
      =/  tape  (trip p.ars)
      [[%leaf tape] q.ars]
    ::
    =/  result  (bind ares to-tang)
    ::
    ?-  foreign-response
      %peel  (mo-give %unto %reap result)
      %peer  (mo-give %unto %reap result)
      %poke  (mo-give %unto %coup result)
      %pull  mo-state
    ==
  ::
  ::  +mo-bale: assign an out bone.
  ::
  ++  mo-bale
    |=  =ship
    ^-  [bone _mo-state]
    ::
    =/  =foreign
      =/  existing  (~(get by contacts.ship-state.gall) ship)
      (fall existing [1 ~ ~])
    ::
    =/  existing  (~(get by index-map.foreign) hen)
    ::
    ?^  existing
      [u.existing mo-state]
    ::
    =/  index  index.foreign
    ::
    =/  new-foreign
      %_  foreign
        index      +(index)
        index-map  (~(put by index-map.foreign) hen index)
        duct-map   (~(put by duct-map.foreign) index hen)
      ==
    ::
    =/  contacts  (~(put by contacts.ship-state.gall) ship new-foreign)
    ::
    =/  next
      %_  mo-state
        contacts.ship-state.gall  contacts
      ==
    ::
    [index next]
  ::
  ::  +mo-ball: retrieve an out bone by index.
  ::
  ++  mo-ball
    |=  [=ship index=@ud]
    ^-  duct
    ::
    =/  =foreign  (~(got by contacts.ship-state.gall) ship)
    (~(got by duct-map.foreign) index)
  ::
  ::  +mo-cyst-core: receive a core.
  ::
  ++  mo-cyst-core
    |=  [=path =sign-arvo]
    ^+  mo-state
    ::
    ?>  ?=([%f %made *] sign-arvo)
    ?>  ?=([@ @ @ @ @ ~] path)
    ::
    =/  beak-path  t.t.path
    ::
    =/  =beak
      =/  =ship  (slav %p i.beak-path)
      =/  =desk  i.t.beak-path
      =/  =case  [%da (slav %da i.t.t.beak-path)]
      [p=ship q=desk r=case]
    ::
    (mo-receive-core i.t.path beak result.sign-arvo)
  ::
  ::  +mo-cyst-pel: translated peer.
  ::
  ++  mo-cyst-pel
    |=  [=path =sign-arvo]
    ^+  mo-state
    ::
    ?>  ?=([%f %made *] sign-arvo)
    ?>  ?=([@ @ ~] path)
    ::
    ?:  ?=([%incomplete *] result.sign-arvo)
      =/  err  (some tang.result.sign-arvo)
      (mo-give %unto %coup err)
    ::
    =/  build-result  build-result.result.sign-arvo
    ::
    ?:  ?=([%error *] build-result)
      =/  err  (some message.build-result)
      (mo-give %unto %coup err)
    ::
    =/  =cage  (result-to-cage:ford build-result)
    (mo-give %unto %diff cage)
  ::
  ::  +mo-cyst-red: diff ack.
  ::
  ++  mo-cyst-red
    |=  [=path =sign-arvo]
    ^+  mo-state
    ::
    ?>  ?=([@ @ @ @ ~] path)
    ::
    ?.  ?=([%a %woot *] sign-arvo)
      ~&  [%red-want path]
      mo-state
    ::
    =/  him  (slav %p i.t.path)
    =/  dap  i.t.t.path
    =/  num  (slav %ud i.t.t.t.path)
    ::
    =/  =coop  q.+>.sign-arvo
    ::
    =/  sys-path
      =/  pax  [%req t.path]
      [%sys pax]
    ::
    ?~  coop
      =/  =note-arvo  [%g %deal [him our] dap %pump ~]
      (mo-pass sys-path note-arvo)
    ::
    =/  gall-move  [%g %deal [him our] dap %pull ~]
    =/  ames-move  [%a %want him [%g %gh dap ~] [num %x ~]]
    ::
    =.  mo-state  (mo-pass sys-path gall-move)
    =.  mo-state  (mo-pass sys-path ames-move)
    ::
    ?.  ?=([~ ~ %mack *] coop)
      ~&  [%diff-bad-ack coop]
      mo-state
    ~&  [%diff-bad-ack %mack]
    =/  print  (slog (flop q.,.+>.coop))
    (print mo-state)
  ::
  ::  +mo-cyst-rep: reverse request.
  ::
  ++  mo-cyst-rep
    |=  [=path =sign-arvo]
    ^+  mo-state
    ::
    ?>  ?=([@ @ @ @ ~] path)
    ?>  ?=([%f %made *] sign-arvo)
    ::
    =/  him  (slav %p i.t.path)
    =/  dap  i.t.t.path
    =/  num  (slav %ud i.t.t.t.path)
    ::
    ?:  ?=([%incomplete *] result.sign-arvo)
      =/  err  (some tang.result.sign-arvo)
      (mo-give %mack err)
    ::
    =/  build-result  build-result.result.sign-arvo
    ::
    ?:  ?=([%error *] build-result)
      ::  XX should crash
      =/  err  (some message.build-result)
      (mo-give %mack err)
    ::
    ::  XX pump should ack
    =.  mo-state  (mo-give %mack ~)
    ::
    =/  duct  (mo-ball him num)
    =/  initialised  (mo-abed duct)
    ::
    =/  =cage  (result-to-cage:ford build-result)
    =/  move  [%unto [%diff cage]]
    ::
    (mo-give:initialised move)
  ::
  ::  +mo-cyst-req: inbound request.
  ::
  ++  mo-cyst-req
    |=  [=path =sign-arvo]
    ^+  mo-state
    ::
    ?>  ?=([@ @ @ @ ~] path)
    ::
    =/  him  (slav %p i.t.path)
    =/  dap  i.t.t.path
    =/  num  (slav %ud i.t.t.t.path)
    ::
    ?:  ?=([%f %made *] sign-arvo)
      ?:  ?=([%incomplete *] result.sign-arvo)
        =/  err  (some tang.result.sign-arvo)
        (mo-give %mack err)
      ::
      =/  build-result  build-result.result.sign-arvo
      ::
      ?:  ?=([%error *] build-result)
        =/  err  (some message.build-result)
        (mo-give %mack err)
      ::
      =/  =cage  (result-to-cage:ford build-result)
      =/  sys-path  [%sys path]
      =/  =note-arvo  [%g %deal [him our] i.t.t.path %poke cage]
      ::
      (mo-pass sys-path note-arvo)
    ::
    ?:  ?=([%a %woot *] sign-arvo)
      mo-state
    ::
    ?>  ?=([%g %unto *] sign-arvo)
    ::
    =/  =internal-gift  +>.sign-arvo
    ::
    ?-    -.internal-gift
        ::
        %coup
        ::
      (mo-give %mack p.internal-gift)
        ::
        %diff
        ::
      =/  sys-path  [%sys %red t.path]
      =/  =note-arvo
        =/  path  [%g %gh dap ~]
        =/  noun  [num %d p.p.internal-gift q.q.p.internal-gift]
        [%a %want him path noun]
      ::
      (mo-pass sys-path note-arvo)
        ::
        %quit
        ::
      =/  sys-path  [%sys path]
      =/  =note-arvo
        =/  path  [%g %gh dap ~]
        =/  noun  [num %x ~]
        [%a %want him path noun]
      ::
      (mo-pass sys-path note-arvo)
        ::
        %reap
        ::
      (mo-give %mack p.internal-gift)
    ==
  ::
  ::  +mo-cyst-val: inbound validate.
  ::
  ++  mo-cyst-val
    |=  [=path =sign-arvo]
    ^+  mo-state
    ::
    ?>  ?=([%f %made *] sign-arvo)
    ?>  ?=([@ @ @ ~] path)
    ::
    =/  =ship  (slav %p i.t.path)
    =/  =dude  i.t.t.path
    ::
    ?:  ?=([%incomplete *] result.sign-arvo)
      =/  err  (some tang.result.sign-arvo)
      (mo-give %unto %coup err)
    ::
    =/  build-result  build-result.result.sign-arvo
    ::
    ?:  ?=([%error *] build-result)
      =/  err  (some message.build-result)
      (mo-give %unto %coup err)
    ::
    =/  =privilege
      =/  =routes  [disclosing=~ attributing=ship]
      [%high routes]
    ::
    =/  =cage  (result-to-cage:ford build-result)
    =/  =agent-action  [%poke cage]
    (mo-clip dude privilege agent-action)
  ::
  ::  +mo-cyst-way: outbound request.
  ::
  ++  mo-cyst-way
    |=  [=path =sign-arvo]
    ^+  mo-state
    ::
    ?>  ?=([%a %woot *] sign-arvo)
    ?>  ?=([@ @ ~] path)
    ::
    =/  =foreign-response  (foreign-response i.t.path)
    =/  art  +>+.sign-arvo
    ::
    (mo-awed foreign-response art)
  ::
  ::  +mo-cyst: take in /sys.
  ::
  ++  mo-cyst
    ~/  %mo-cyst
    |=  [=path =sign-arvo]
    ^+  mo-state
    ::
    ?+  -.path  !!
      %core  (mo-cyst-core path sign-arvo)
      %pel  (mo-cyst-pel path sign-arvo)
      %red  (mo-cyst-red path sign-arvo)
      %rep  (mo-cyst-rep path sign-arvo)
      %req  (mo-cyst-req path sign-arvo)
      %val  (mo-cyst-val path sign-arvo)
      %way  (mo-cyst-way path sign-arvo)
    ==
  ::
  ::  +mo-cook: take in /use.
  ::
  ++  mo-cook
    ~/  %mo-cook
    |=  [=path hin=(hypo sign-arvo)]
    ^+  mo-state
    ::
    ?.  ?=([@ @ coke *] path)
      ~&  [%mo-cook-bad-path path]
      !!
    ::
    =/  initialised
      =/  =term  i.path
      =/  =privilege
        =/  =ship  (slav %p i.t.path)
        =/  =routes  [disclosing=~ attributing=ship]
        [%high routes]
      ::
      (ap-abed:ap term privilege)
    ::
    =/  =vase  (slot 3 hin)
    =/  =sign-arvo  q.hin
    ::
    ?-  i.t.t.path
        ::
        %inn
        ::
      =/  poured  (ap-pour:initialised t.t.t.path vase)
      ap-abet:poured
        ::
        %cay
        ::
      ?.  ?=([%e %sigh *] sign-arvo)
        ~&  [%mo-cook-weird sign-arvo]
        ~&  [%mo-cook-weird-path path]
        mo-state
      ::
      =/  purred
        =/  =cage  +>.sign-arvo
        (ap-purr:initialised %sigh t.t.t.path cage)
      ::
      ap-abet:purred
        ::
        %out
        ::
      ?.  ?=([%g %unto *] sign-arvo)
        ~&  [%mo-cook-weird sign-arvo]
        ~&  [%mo-cook-weird-path path]
        mo-state
      ::
      =/  pouted
        =/  =internal-gift  +>.sign-arvo
        (ap-pout:initialised t.t.t.path internal-gift)
      ::
      ap-abet:pouted
    ==
  ::
  ::  +mo-claw: clear queue.
  ::
  ++  mo-claw
    |=  =dude
    ^+  mo-state
    ::
    ?.  (~(has by running.ship-state.gall) dude)
      mo-state
    ::
    =/  maybe-blocked  (~(get by waiting.ship-state.gall) dude)
    ::
    ?~  maybe-blocked
      mo-state
    ::
    =/  =blocked  u.maybe-blocked
    ::
    |-  ^+  mo-state
    ::
    ?:  =(~ blocked)
      %_  mo-state
        waiting.ship-state.gall  (~(del by waiting.ship-state.gall) dude)
      ==
    ::
    =^  kiss  blocked  [p q]:~(get to blocked)
    ::
    =/  =duct  p.kiss
    =/  =privilege  q.kiss
    =/  =agent-action  r.kiss
    ::
    =/  move
      =/  =sock  [attributing.routes.privilege our]
      =/  =internal-task  [dude agent-action]
      =/  card  [%slip %g %deal sock internal-task]
      [duct card]
    ::
    $(moves [move moves])
  ::
  ::  +mo-beak: build beak.
  ::
  ++  mo-beak
    |=  =dude
    ^-  beak
    ::
    =/  =beak
      =/  running  (~(got by running.ship-state.gall) dude)
      beak.running
    ::
    =/  =ship  p.beak
    ::
    ?.  =(ship our)
      beak
    beak(r [%da now])
  ::
  ::  +mo-peek: scry.
  ::
  ++  mo-peek
    ~/  %mo-peek
    |=  [=dude =privilege =term =path]
    ^-  (unit (unit cage))
    ::
    =/  initialised  (ap-abed:ap dude privilege)
    (ap-peek:initialised term path)
  ::
  ::  +mo-clip: apply action.
  ::
  ++  mo-clip
    |=  [=dude =privilege =agent-action]
    ^+  mo-state
    ::
    =/  =path
      =/  ship  (scot %p attributing.routes.privilege)
      /sys/val/[ship]/[dude]
    ::
    =/  ship-desk
      =/  =beak  (mo-beak dude)
      [p q]:beak
    ::
    ?:  ?=(%puff -.agent-action)
      =/  =schematic:ford  [%vale ship-desk +.agent-action]
      =/  =note-arvo  [%f %build live=%.n schematic]
      (mo-pass path note-arvo)
    ::
    ?:  ?=(%punk -.agent-action)
      =/  =schematic:ford  [%cast ship-desk p.agent-action [%$ q.agent-action]]
      =/  =note-arvo  [%f %build live=%.n schematic]
      (mo-pass path note-arvo)
    ::
    ?:  ?=(%peer-not -.agent-action)
      =/  err  (some p.agent-action)
      (mo-give %unto %reap err)
    ::
    =/  initialised  (ap-abed:ap dude privilege)
    =/  applied  (ap-agent-action:initialised agent-action)
    ap-abet:applied
  ::
  ::  +mo-come: handle locally.
  ::
  ++  mo-come
    |=  [=ship =internal-task]
    ^+  mo-state
    ::
    =/  =privilege
      =/  =routes  [disclosing=~ attributing=ship]
      [%high routes]
    ::
    =/  =dude  p.internal-task
    =/  =agent-action  q.internal-task
    ::
    =/  is-running  (~(has by running.ship-state.gall) dude)
    =/  is-waiting  (~(has by waiting.ship-state.gall) dude)
    ::
    ?:  |(!is-running is-waiting)
      ::
      =/  =blocked
        =/  waiting  (~(get by waiting.ship-state.gall) dude)
        =/  kisses  (fall waiting *blocked)
        =/  kiss  [hen privilege agent-action]
        (~(put to kisses) kiss)
      ::
      =/  waiting  (~(put by waiting.ship-state.gall) dude blocked)
      ::
      %_  mo-state
        waiting.ship-state.gall  waiting
      ==
    ::
    (mo-clip dude privilege agent-action)
  ::
  ::  +mo-gawk: ames forward.
  ::
  ++  mo-gawk
    |=  [=ship =dude =bone =forward-ames]
    ^+  mo-state
    ::
    =.  mo-state
      ?.  ?=(%u action.forward-ames)
        mo-state
      (mo-give %mack ~)
    ::
    =/  =path
      =/  him  (scot %p ship)
      =/  num  (scot %ud bone)
      /sys/req/[him]/[dude]/[num]
    ::
    =/  =sock  [ship our]
    ::
    =/  =note-arvo
      ?-  action.forward-ames
          ::
          %m
          ::
        =/  =task:able
          =/  =internal-task  [dude %puff [mark noun]:forward-ames]
          [%deal sock internal-task]
        [%g task]
          ::
          %l
          ::
        =/  =task:able
          =/  =internal-task  [dude %peel [mark path]:forward-ames]
          [%deal sock internal-task]
        [%g task]
          ::
          %s
          ::
        =/  =task:able
          =/  =internal-task  [dude %peer path.forward-ames]
          [%deal sock internal-task]
        [%g task]
          ::
          %u
          ::
        =/  =task:able
          =/  =internal-task  [dude %pull ~]
          [%deal sock internal-task]
        [%g task]
      ==
    ::
    (mo-pass path note-arvo)
  ::
  ::  +mo-gawd: ames backward.
  ::
  ++  mo-gawd
    |=  [=ship =dude =bone =reverse-ames]
    ^+  mo-state
    ::
    ?-    action.reverse-ames
        ::
        %d
        ::
      =/  =path
        =/  him  (scot %p ship)
        =/  num  (scot %ud bone)
        /sys/rep/[him]/[dude]/[num]
      ::
      =/  =note-arvo
        =/  beak  (mo-beak dude)
        =/  info  [p q]:beak
        =/  =schematic:ford  [%vale info p.reverse-ames q.reverse-ames]
        [%f %build live=%.n schematic]
      ::
      (mo-pass path note-arvo)
        ::
        %x
        ::
      ::  XX should crash
      =.  mo-state  (mo-give %mack ~)
      ::
      =/  initialised
        =/  out  (mo-ball ship bone)
        (mo-abed out)
      ::
      (mo-give:initialised %unto %quit ~)
    ==
  ::
  ::  +ap: agent engine
  ::
  ++  ap
    ~%  %gall-ap  +>  ~
    ::
    |_  $:  dap=dude
            pry=privilege
            ost=bone
            zip=(list internal-move)
            dub=(list (each suss tang))
            sat=agent
        ==
    ::
    ++  ap-state  .
    ::
    ::  +ap-abed: initialise the provided app with the supplied privilege.
    ::
    ++  ap-abed
      ~/  %ap-abed
      |=  [=dude =privilege]
      ^+  ap-state
      ::
      =/  =agent
        =/  running  (~(got by running.ship-state.gall) dude)
        =/  =stats
          =/  change  +(change.stats.running)
          =/  trop  (shaz (mix (add dude change) eny))
          [change=change eny=trop time=now]
        running(stats stats)
      ::
      =/  maybe-bone  (~(get by bone-map.ducts.agent) hen)
      ::
      ?^  maybe-bone
        =/  bone  u.maybe-bone
        ap-state(dap dude, pry privilege, sat agent, ost bone)
      ::
      =/  =opaque-ducts
        =/  bone  +(bone.ducts.agent)
        :+  bone=bone
          bone-map=(~(put by bone-map.ducts.agent) hen bone)
        duct-map=(~(put by duct-map.ducts.agent) bone hen)
      ::
      %=  ap-state
        ost        bone.ducts.agent
        ducts.sat  opaque-ducts
      ==
    ::
    ::  +ap-abet: resolve moves.
    ::
    ++  ap-abet
      ^+  mo-state
      ::
      =>  ap-abut
      ::
      =/  running  (~(put by running.ship-state.gall) dap sat)
      ::
      =/  moves
        =/  from-internal  (turn zip ap-aver)
        =/  from-suss  (turn dub ap-avid)
        :(weld from-internal from-suss moves)
      ::
      %_  mo-state
        running.ship-state.gall  running
        moves                    moves
      ==
    ::
    ::  +ap-abut: track queue.
    ::
    ++  ap-abut
      ^+  ap-state
      ::
      =/  internal-moves  zip
      =/  bones  *(set bone)
      ::
      |-  ^+  ap-state
      ::
      ?^  internal-moves
        ?.  ?=([%give %diff *] move.i.internal-moves)
          $(internal-moves t.internal-moves)
        ::
        =/  =internal-move  i.internal-moves
        =^  filled  ap-state  ap-fill(ost bone.internal-move)
        ::
        =/  new-bones
          ?:  filled
            bones
          (~(put in bones) bone.internal-move)
        ::
        $(internal-moves t.internal-moves, bones new-bones)
      ::
      =/  boned  ~(tap in bones)
      ::
      |-  ^+  ap-state
      ::
      ?~  boned
        ap-state
      ::
      =>  $(boned t.boned, ost i.boned)
      ::
      =/  tib  (~(get by incoming.subscribers.sat) ost)
      ::
      ?~  tib
        ~&  [%ap-abut-bad-bone dap ost]
        ap-state
      ::
      ap-kill(attributing.routes.pry p.u.tib)
    ::
    ::  +ap-aver: internal move to move.
    ::
    ++  ap-aver
      ~/  %ap-aver
      |=  =internal-move
      ^-  move
      ::
      =/  =duct  (~(got by duct-map.ducts.sat) bone.internal-move)
      =/  card
        ?-    -.move.internal-move
            ::
            %slip  !!
            ::
            %sick  !!
            ::
            %give
            ::
          ?<  =(0 bone.internal-move)
          ::
          =/  =internal-gift  p.move.internal-move
          ?.  ?=(%diff -.internal-gift)
            [%give %unto internal-gift]
          ::
          =/  =cage  p.internal-gift
          =/  =mark
            =/  trans  (~(get by required-trans.sat) bone.internal-move)
            (fall trans p.cage)
          ::
          ?:  =(mark p.cage)
            [%give %unto internal-gift]
          ::
          =/  =path  /sys/pel/[dap]
          ::
          =/  =note-arvo
            =/  =schematic:ford
              =/  =beak  (mo-beak dap)
              [%cast [p q]:beak mark [%$ cage]]
            [%f %build live=%.n schematic]
          ::
          [%pass path note-arvo]
            ::
            %pass
            ::
          =/  =path  p.move.internal-move
          =/  =internal-note  q.move.internal-move
          ::
          =/  use-path  [%use dap path]
          ::
          =/  =note-arvo
            ?-  task.internal-note
                ::
                %hiss
                ::
              [%e %hiss [knot mark cage]:internal-note]
                ::
                %send
                ::
              =/  =sock  [our ship.internal-note]
              =/  =internal-task  internal-task.internal-note
              [%g %deal sock internal-task]
                ::
                %meta
                ::
              =/  =term  term.internal-note
              =/  =vase  vase.internal-note
              [term %meta vase]
            ==
          ::
          [%pass use-path note-arvo]
        ==
      ::
      [duct card]
    ::
    ::  +ap-avid: onto results.
    ::
    ++  ap-avid
      |=  report=(each suss tang)
      ^-  move
      ::
      [hen %give %onto report]
    ::
    ::  +ap-call: call into server.
    ::
    ++  ap-call
      ~/  %ap-call
      |=  [=term =vase]
      ^-  [(unit tang) _ap-state]
      ::
      =.  ap-state  ap-bowl
      =^  arm  ap-state  (ap-farm term)
      ::
      ?:  ?=(%.n -.arm)
        [(some p.arm) ap-state]
      ::
      =^  arm  ap-state  (ap-slam term p.arm vase)
      ::
      ?:  ?=(%.n -.arm)
        [(some p.arm) ap-state]
      (ap-sake p.arm)
    ::
    ::  +ap-peek: peek.
    ::
    ++  ap-peek
      ~/  %ap-peek
      |=  [=term tyl=path]
      ^-  (unit (unit cage))
      ::
      =/  marked
        ?.  ?=(%x term)
          [mark=%$ tyl=tyl]
        ::
        =/  =path  (flop tyl)
        ::
        ?>  ?=(^ path)
        [mark=i.path tyl=(flop t.path)]
      ::
      =/  =mark  mark.marked
      =/  tyl  tyl.marked
      ::
      =^  maybe-arm  ap-state  (ap-find %peek term tyl)
      ::
      ?~  maybe-arm
        =/  =tank  [%leaf "peek find fail"]
        =/  print  (slog tank >tyl< >mark< ~)
        (print [~ ~])
      ::
      =^  arm  ap-state  (ap-farm q.u.maybe-arm)
      ::
      ?:  ?=(%.n -.arm)
        =/  =tank  [%leaf "peek farm fail"]
        =/  print  (slog tank p.arm)
        (print [~ ~])
      ::
      =/  slammed
        =/  index  p.u.maybe-arm
        =/  term  q.u.maybe-arm
        =/  =vase
          =/  =path  [term tyl]
          =/  raw  (slag index path)
          !>  raw
        (ap-slam term p.arm vase)
      ::
      =^  possibly-vase  ap-state  slammed
      ::
      ?:  ?=(%.n -.possibly-vase)
        =/  =tank  [%leaf "peek slam fail"]
        =/  print  (slog tank p.possibly-vase)
        (print [~ ~])
      ::
      =/  slammed-vase  p.possibly-vase
      =/  vase-value  q.slammed-vase
      ::
      =/  err
        =/  =tank  [%leaf "peek bad result"]
        =/  print  (slog tank ~)
        (print [~ ~])
      ::
      ?+  vase-value  err
          ::
          ~
          ::
        ~
          ::
          [~ ~]
          ::
        [~ ~]
          ::
          [~ ~ ^]
          ::
        =/  =vase  (sped (slot 7 slammed-vase))
        ::
        ?.  ?=([p=@ *] q.vase)
          =/  =tank  [%leaf "scry: malformed cage"]
          =/  print  (slog tank ~)
          (print [~ ~])
        ::
        ?.  ((sane %as) p.q.vase)
          =/  =tank  [%leaf "scry: malformed cage"]
          =/  print  (slog tank ~)
          (print [~ ~])
        ::
        ?.  =(mark p.q.vase)
          [~ ~]
        ::
        =/  =cage  [p.q.vase (slot 3 vase)]
        (some (some cage))
      ==
    ::
    ::  +ap-agent-action: apply effect.
    ::
    ++  ap-agent-action
      |=  =agent-action
      ^+  ap-state
      ::
      ?-  -.agent-action
        %peel       (ap-peel +.agent-action)
        %poke       (ap-poke +.agent-action)
        %peer       (ap-peer +.agent-action)
        %puff       !!
        %punk       !!
        %peer-not   !!
        %pull       ap-pull
        %pump       ap-fall
      ==
    ::
    ::  +ap-diff: pour a diff.
    ::
    ++  ap-diff
      ~/  %ap-diff
      |=  [=ship =path =cage]
      ^+  ap-state
      ::
      =/  rest  +.path
      =/  diff  [%diff p.cage rest]
      ::
      =^  maybe-arm  ap-state  (ap-find diff)
      ::
      ?~  maybe-arm
        =/  target  [%.n ship rest]
        ::
        =/  =tang
          =/  why  "diff: no {<[p.cage rest]>}"
          (ap-suck why)
        ::
        =/  lame  (ap-lame %diff tang)
        (ap-pump:lame target)
      ::
      =/  arm  u.maybe-arm
      ::
      =/  =vase
        =/  target
          ?:  =(0 p.arm)
            [!>(rest) !>(cage)]
          [!>((slag (dec p.arm) rest)) q.cage]
        (slop target)
      ::
      =^  called  ap-state  (ap-call q.arm vase)
      ::
      ?^  called
        =/  lame  (ap-lame q.arm u.called)
        (ap-pump:lame %.n ship path)
      (ap-pump %.y ship path)
    ::
    ::  +ap-pump: update subscription.
    ::
    ++  ap-pump
      ~/  %ap-pump
      |=  [is-ok=? =ship =path]
      ^+  ap-state
      ::
      =/  way  [(scot %p ship) %out path]
      ::
      ?:  is-ok
        =/  =internal-note  [%send ship -.path %pump ~]
        (ap-pass way internal-note)
      ::
      =/  give  (ap-give %quit ~)
      =/  =internal-note  [%send ship -.path %pull ~]
      (ap-pass:give way internal-note)
    ::
    ::  +ap-fail: drop from queue.
    ::
    ++  ap-fall
      ^+  ap-state
      ::
      ?.  (~(has by incoming.subscribers.sat) ost)
        ap-state
      ::
      =/  level  (~(get by meter.subscribers.sat) ost)
      ::
      ?:  |(?=(~ level) =(0 u.level))
        ap-state
      ::
      =.  u.level  (dec u.level)
      ::
      ?:  =(0 u.level)
        =/  deleted  (~(del by meter.subscribers.sat) ost)
        %_  ap-state
          meter.subscribers.sat  deleted
        ==
      ::
      =/  dropped  (~(put by meter.subscribers.sat) ost u.level)
      ap-state(meter.subscribers.sat dropped)
    ::
    ::  +ap-farm: produce arm.
    ::
    ++  ap-farm
      ~/  %ap-farm
      |=  =term
      ^-  [(each vase tang) _ap-state]
      ::
      =/  compiled
        =/  cache  cache.sat
        =/  =type  p.running-state.sat
        (~(mint wa cache) type [%limb term])
      ::
      =/  virtual
        =/  trap  |.(compiled)
        (mule trap)
      ::
      ?:  ?=(%.n -.virtual)
        =/  =tang  p.virtual
        [[%.n tang] ap-state]
      ::
      =/  possibly-vase=(each vase tang)
        =/  value  q.running-state.sat
        =/  ton  (mock [value q.+<.virtual] ap-sled)
        ?-  -.ton
          %0  [%.y p.+<.virtual p.ton]
          %1  [%.n (turn p.ton |=(a=* (smyt (path a))))]
          %2  [%.n p.ton]
        ==
      ::
      =/  next
        =/  =worm  +>.virtual
        %_  ap-state
          cache.sat  worm
        ==
      ::
      [possibly-vase next]
    ::
    ::  +ap-fill: add to queue.
    ::
    ++  ap-fill
      ^-  [? _ap-state]
      ::
      =/  meter
        =/  level  (~(get by meter.subscribers.sat) ost)
        (fall level 0)
      ::
      =/  =ship
        =/  incoming  (~(got by incoming.subscribers.sat) ost)
        p.incoming
      ::
      =/  incoming  (~(get by incoming.subscribers.sat) ost)
      =/  duct  (~(get by duct-map.ducts.sat) ost)
      ::
      ?:  &(=(20 meter) !=(our ship))
        ~&  [%gall-pulling-20 ost incoming duct]
        [%.n ap-state]
      ::
      =/  next
        =/  meter  (~(put by meter.subscribers.sat) ost +(meter))
        %_  ap-state
          meter.subscribers.sat  meter
        ==
      ::
      [%.y next]
    ::
    ::  +ap-find: general arm.
    ::
    ++  ap-find
      ~/  %ap-find
      |=  [=term =path]
      ^-  [(unit (pair @ud @tas)) _ap-state]
      ::
      =/  maybe-cached  (~(get by find-cache.sat) [term path])
      ?^  maybe-cached
        [u.maybe-cached ap-state]
      ::
      =/  result
        =/  dep  0
        |-  ^-  (unit (pair @ud @tas))
        =/  spu
          ?~  path
            ~
          =/  hyped  (cat 3 term (cat 3 '-' i.path))
          $(path t.path, dep +(dep), term hyped)
        ::
        ?^  spu
          spu
        ::
        ?.  (ap-fond term)
          ~
        (some [dep term])
      ::
      =.  find-cache.sat  (~(put by find-cache.sat) [term path] result)
      ::
      [result ap-state]
    ::
    ::  +ap-fond: check for arm.
    ::
    ++  ap-fond
      ~/  %ap-fond
      |=  =term
      ^-  ?
      ::
      =/  =type  p.running-state.sat
      (slob term type)
    ::
    ::  +ap-give: return result.
    ::
    ++  ap-give
      |=  =internal-gift
      ^+  ap-state
      ::
      =/  internal-moves
        =/  move  [%give internal-gift]
        =/  =internal-move  [ost move]
        [internal-move zip]
      ::
      ap-state(zip internal-moves)
    ::
    ::  +ap-bowl: set up bowl.
    ::
    ++  ap-bowl
      ^+  ap-state
      ::
      %_    ap-state
          +12.q.running-state.sat
        :: FIXME better bowl
        ^-   bowl
        :*  :*  our                               ::  host
                attributing.routes.pry            ::  guest
                dap                               ::  agent
            ==                                    ::
            :*  wex=~                             ::  outgoing
                sup=incoming.subscribers.sat ::  incoming
            ==                                    ::
            :*  ost=ost                           ::  cause
                act=change.stats.sat           ::  tick
                eny=eny.stats.sat                 ::  nonce
                now=time.stats.sat                ::  time
                byk=beak.sat                      ::  source
        ==  ==                                    ::
      ==
    ::
    ::  +ap-move: process each move.
    ::
    ++  ap-move
      ~/  %ap-move
      |=  =vase
      ^-  [(each internal-move tang) _ap-state]
      ::
      =/  value  q.vase
      ::
      ?@  value
        =/  =tang  (ap-suck "move: invalid move (atom)")
        [[%.n tang] ap-state]
      ::
      ?^  -.value
        =/  =tang  (ap-suck "move: invalid move (bone)")
        [[%.n tang] ap-state]
      ::
      ?@  +.value
        =/  =tang  (ap-suck "move: invalid move (card)")
        [[%.n tang] ap-state]
      ::
      =/  has-duct  (~(has by duct-map.ducts.sat) -.value)
      ::
      ?.  &(has-duct !=(0 -.value))
        =/  =tang  (ap-suck "move: invalid card (bone {<-.value>})")
        [[%.n tang] ap-state]
      ::
      =^  spotted  cache.sat  (~(spot wa cache.sat) 3 vase)
      =^  slotted  cache.sat  (~(slot wa cache.sat) 3 spotted)
      ::
      ?+  +<.value  (ap-move-pass -.value +<.value slotted)
        %diff  (ap-move-diff -.value slotted)
        %hiss  (ap-move-hiss -.value slotted)
        %peel  (ap-move-peel -.value slotted)
        %peer  (ap-move-peer -.value slotted)
        %pull  (ap-move-pull -.value slotted)
        %poke  (ap-move-poke -.value slotted)
        %send  (ap-move-send -.value slotted)
        %quit  (ap-move-quit -.value slotted)
      ==
    ::
    ::  +ap-move-quit: give quit move.
    ::
    ++  ap-move-quit
      ~/  %quit
      |=  [=bone =vase]
      ^-  [(each internal-move tang) _ap-state]
      ::
      =/  possibly-internal-move=(each internal-move tang)
        ?^  q.vase
          =/  =tang  (ap-suck "quit: improper give")
          [%.n tang]
        ::
        =/  =internal-move
          =/  =internal-gift  [%quit ~]
          =/  move  [%give internal-gift]
          [bone move]
        ::
        [%.y internal-move]
      ::
      =/  next
        =/  incoming  (~(del by incoming.subscribers.sat) bone)
        %_  ap-state
          incoming.subscribers.sat  incoming
        ==
      ::
      [possibly-internal-move next]
    ::
    ::  +ap-move-diff: give diff move.
    ::
    ++  ap-move-diff
      ~/  %diff
      |=  [=bone =vase]
      ^-  [(each internal-move tang) _ap-state]
      ::
      =^  specialised  cache.sat  (~(sped wa cache.sat) vase)
      ::
      =/  value  q.specialised
      ::
      ?.  ?&  ?=(^ value)
              ?=(@ -.value)
              ((sane %tas) -.value)
          ==
        =/  =tang  (ap-suck "diff: improper give")
        [[%.n tang] ap-state]
      ::
      =^  at-slot  cache.sat  (~(slot wa cache.sat) 3 specialised)
      ::
      =/  =internal-move
        =/  =cage  [-.value at-slot]
        =/  move  [%give %diff cage]
        [bone move]
      ::
      [[%.y internal-move] ap-state]
    ::
    ::  +ap-move-hiss: pass %hiss.
    ::
    ++  ap-move-hiss
      ~/  %hiss
      |=  [=bone =vase]
      ^-  [(each internal-move tang) _ap-state]
      ::
      ?.  ?&  ?=([p=* q=* r=@ s=[p=@ *]] q.vase)
              ((sane %tas) r.q.vase)
          ==
        =/  =tang
          =/  args  "[%hiss wire (unit knot) mark cage]"
          (ap-suck "hiss: bad hiss ask.{args}")
        [[%.n tang] ap-state]
      ::
      =^  at-slot  cache.sat  (~(slot wa cache.sat) 15 vase)
      ::
      ?.  ?&  ?=([p=@ *] q.at-slot)
              ((sane %tas) p.q.at-slot)
          ==
        =/  =tang  (ap-suck "hiss: malformed cage")
        [[%.n tang] ap-state]
      ::
      =/  pax  ((soft path) p.q.vase)
      ::
      ?.  ?&  ?=(^ pax)
              (levy u.pax (sane %ta))
          ==
        =/  =tang  (ap-suck "hiss: malformed path")
        [[%.n tang] ap-state]
      ::
      =/  usr  ((soft (unit knot)) q.q.vase)
      ::
      ?.  ?&  ?=(^ usr)
              ?~(u.usr & ((sane %ta) u.u.usr))
          ==
        =/  =tang  (ap-suck "hiss: malformed (unit knot)")
        [[%.n tang] ap-state]
      ::
      =^  specialised  cache.sat  (~(stop wa cache.sat) 3 at-slot)
      ::
      =/  =internal-move
        =/  =path  [(scot %p attributing.routes.pry) %cay u.pax]
        =/  =cage  [p.q.at-slot specialised]
        =/  =internal-note  [%hiss u.usr r.q.vase cage]
        =/  card  [%pass path internal-note]
        [bone card]
      ::
      [[%.y internal-move] ap-state]
    ::
    ::  +ap-move-mess: extract path, target.
    ::
    ++  ap-move-mess
      ~/  %mess
      |=  =vase
      ^-  [(each (trel path ship term) tang) _ap-state]
      ::
      =/  possibly-trel=(each (trel path ship term) tang)
        ?.  ?&  ?=([p=* [q=@ r=@] s=*] q.vase)
                (gte 1 (met 7 q.q.vase))
            ==
          =/  =tang  (ap-suck "mess: malformed target")
          [%.n tang]
        ::
        =/  pax  ((soft path) p.q.vase)
        ::
        ?.  ?&  ?=(^ pax)
                (levy u.pax (sane %ta))
            ==
          =/  =tang  (ap-suck "mess: malformed path")
          [%.n tang]
        ::
        =/  =path  [(scot %p q.q.vase) %out r.q.vase u.pax]
        =/  =ship  q.q.vase
        =/  =term  r.q.vase
        [%.y path ship term]
      ::
      [possibly-trel ap-state]
    ::
    ::  +ap-move-pass: pass general move.
    ::
    ++  ap-move-pass
      ~/  %pass
      |=  [=bone =noun =vase]
      ^-  [(each internal-move tang) _ap-state]
      ::
      ?.  ?&  ?=(@ noun)
              ((sane %tas) noun)
          ==
        =/  =tang  (ap-suck "pass: malformed card")
        [[%.n tang] ap-state]
      ::
      =/  pax  ((soft path) -.q.vase)
      ::
      ?.  ?&  ?=(^ pax)
              (levy u.pax (sane %ta))
          ==
        =/  =tang  (ap-suck "pass: malformed path")
        [[%.n tang] ap-state]
      ::
      =/  maybe-vane  (ap-vain noun)
      ::
      ?~  maybe-vane
        =/  =tang  (ap-suck "move: unknown note {(trip noun)}")
        [[%.n tang] ap-state]
      ::
      =/  vane  u.maybe-vane
      ::
      =^  at-slot  cache.sat  (~(slot wa cache.sat) 3 vase)
      ::
      =/  =internal-move
        =/  =path  [(scot %p attributing.routes.pry) %inn u.pax]
        =/  vase  (ap-term %tas noun)
        =/  combined  (slop vase at-slot)
        =/  =internal-note  [%meta vane combined]
        =/  card  [%pass path internal-note]
        [bone card]
      ::
      [[%.y internal-move] ap-state]
    ::
    ::  +ap-move-poke: pass %poke.
    ::
    ++  ap-move-poke
      ~/  %poke
      |=  [=bone =vase]
      ^-  [(each internal-move tang) _ap-state]
      ::
      =^  possibly-target  ap-state  (ap-move-mess vase)
      ::
      ?:  ?=(%.n -.possibly-target)
        [possibly-target ap-state]
      ::
      =^  at-slot  cache.sat  (~(slot wa cache.sat) 7 vase)
      ::
      ?.  ?&  ?=([p=@ q=*] q.at-slot)
              ((sane %tas) p.q.at-slot)
          ==
        =/  =tang  (ap-suck "poke: malformed cage")
        [[%.n tang] ap-state]
      ::
      =^  specialised  cache.sat  (~(stop wa cache.sat) 3 at-slot)
      ::
      =/  target  p.possibly-target
      =/  =path  p.target
      =/  =ship  q.target
      =/  =term  r.target
      ::
      =/  =internal-move
        =/  =internal-task  [term %poke p.q.at-slot specialised]
        =/  =internal-note  [%send ship internal-task]
        =/  card  [%pass path internal-note]
        [bone card]
      ::
      [[%.y internal-move] ap-state]
    ::
    ::  +ap-move-peel: pass %peel.
    ::
    ++  ap-move-peel
      ~/  %peel
      |=  [=bone =vase]
      ^-  [(each internal-move tang) _ap-state]
      ::
      =^  possibly-target  ap-state  (ap-move-mess vase)
      ::
      ?:  ?=(%.n -.possibly-target)
        [possibly-target ap-state]
      ::
      =/  target  p.possibly-target
      =/  =ship  q.target
      =/  =term  r.target
      ::
      =/  mark  ((soft mark) +>-.q.vase)
      ::
      ?~  mark
        =/  =tang  (ap-suck "peel: malformed mark")
        [[%.n tang] ap-state]
      ::
      =/  pax  ((soft path) +>+.q.vase)
      ::
      ?.  ?&  ?=(^ pax)
              (levy u.pax (sane %ta))
          ==
        =/  =tang  (ap-suck "peel: malformed path")
        [[%.n tang] ap-state]
      ::
      =/  move
        ?:  (~(has in misvale.sat) p.target)
          =/  =internal-task
            =/  =tang  [[%leaf "peel: misvalidation encountered"] ~]
            =/  =agent-action  [%peer-not tang]
            [term agent-action]
          ::
          =/  =internal-note  [%send ship internal-task]
          =/  card  [%pass p.target internal-note]
          [bone card]
        ::
        =/  =agent-action  [%peel u.mark u.pax]
        =/  =internal-task  [term agent-action]
        =/  =internal-note  [%send ship internal-task]
        =/  card  [%pass p.target internal-note]
        [bone card]
      ::
      [[%.y move] ap-state]
    ::
    ::  +ap-move-peer: pass %peer.
    ::
    ++  ap-move-peer
      ~/  %peer
      |=  [=bone =vase]
      ^-  [(each internal-move tang) _ap-state]
      ::
      =^  possibly-target  ap-state  (ap-move-mess vase)
      ::
      ?:  ?=(%.n -.possibly-target)
        [possibly-target ap-state]
      ::
      =/  target  p.possibly-target
      =/  =ship  q.target
      =/  =term  r.target
      ::
      =/  pax  ((soft path) +>.q.vase)
      ::
      ?.  ?&  ?=(^ pax)
              (levy u.pax (sane %ta))
          ==
        =/  =tang  (ap-suck "peer: malformed path")
        [[%.n tang] ap-state]
      ::
      =/  move
        ?:  (~(has in misvale.sat) p.target)
          =/  err  [[%leaf "peer: misvalidation encountered"] ~]
          =/  =agent-action  [%peer-not err]
          =/  =internal-note  [%send ship term agent-action]
          =/  card  [%pass p.target internal-note]
          [bone card]
        ::
        =/  =agent-action  [%peer u.pax]
        =/  =internal-note  [%send ship term agent-action]
        =/  card  [%pass p.target internal-note]
        [bone card]
      ::
      [[%.y move] ap-state]
    ::
    ::  +ap-move-pull: pass %pull.
    ::
    ++  ap-move-pull
      ~/  %pull
      |=  [=bone =vase]
      ^-  [(each internal-move tang) _ap-state]
      ::
      =^  possibly-target  ap-state  (ap-move-mess vase)
      ::
      ?:  ?=(%.n -.possibly-target)
        [possibly-target ap-state]
      ::
      =/  target  p.possibly-target
      =/  =ship  q.target
      =/  =term  r.target
      ::
      ?.  =(~ +>.q.vase)
        =/  =tang  (ap-suck "pull: malformed card")
        [[%.n tang] ap-state]
      ::
      =/  move
        =/  =agent-action  [%pull ~]
        =/  =internal-note  [%send ship term agent-action]
        =/  card  [%pass p.target internal-note]
        [bone card]
      ::
      [[%.y move] ap-state]
    ::
    ::  +ap-move-send: pass gall action.
    ::
    ++  ap-move-send
      ~/  %send
      |=  [=bone =vase]
      ^-  [(each internal-move tang) _ap-state]
      ::
      ?.  ?&  ?=([p=* [q=@ r=@] [s=@ t=*]] q.vase)
              (gte 1 (met 7 q.q.vase))
              ((sane %tas) r.q.vase)
          ==
        =/  =tang  (ap-suck "send: improper ask.[%send wire gill agent-action]")
        [[%.n tang] ap-state]
      ::
      =/  pax  ((soft path) p.q.vase)
      ::
      ?.  ?&  ?=(^ pax)
              (levy u.pax (sane %ta))
          ==
        =/  =tang  (ap-suck "send: malformed path")
        [[%.n tang] ap-state]
      ::
      ?:  ?=($poke s.q.vase)
        ::
        =^  specialised  cache.sat  (~(spot wa cache.sat) 7 vase)
        ::
        ?>  =(%poke -.q.specialised)
        ::
        ?.  ?&  ?=([p=@ q=*] t.q.vase)
                ((sane %tas) p.t.q.vase)
            ==
          =/  =tang  (ap-suck "send: malformed poke")
          [[%.n tang] ap-state]
        ::
        =^  specialised  cache.sat  (~(spot wa cache.sat) 3 specialised)
        =^  at-slot  cache.sat  (~(slot wa cache.sat) 3 specialised)
        ::
        =/  move
          =/  =agent-action  [%poke p.t.q.vase at-slot]
          =/  =internal-note  [%send q.q.vase r.q.vase agent-action]
          =/  =path  [(scot %p q.q.vase) %out r.q.vase u.pax]
          =/  card  [%pass path internal-note]
          [bone card]
        ::
        [[%.y move] ap-state]
      ::
      =/  maybe-action  ((soft agent-action) [s t]:q.vase)
      ?~  maybe-action
        =/  =tang  (ap-suck "send: malformed agent-action")
        [[%.n tang] ap-state]
      ::
      =/  move
        =/  =agent-action  u.maybe-action
        =/  =internal-note  [%send q.q.vase r.q.vase agent-action]
        =/  =path  [(scot %p q.q.vase) %out r.q.vase u.pax]
        =/  card  [%pass path internal-note]
        [bone card]
      ::
      [[%.y move] ap-state]
    ::
    ::  +ap-pass: request action.
    ::
    ++  ap-pass
      |=  [=path =internal-note]
      ^+  ap-state
      ::
      =/  =internal-move
        =/  move  [%pass path internal-note]
        [ost move]
      ::
      =/  internal-moves  [internal-move zip]
      ::
      ap-state(zip internal-moves)
    ::
    ::  +ap-peep: reinstall.
    ::
    ++  ap-peep
      ~/  %ap-peep
      |=  =vase
      ^+  ap-state
      ::
      =/  prep
        =/  installed  ap-prep(running-state.sat vase)
        =/  running  (some running-state.sat)
        (installed running)
      ::
      =^  maybe-tang  ap-state  prep
      ::
      ?~  maybe-tang
        ap-state
      (ap-lame %prep-failed u.maybe-tang)
    ::
    ::  +ap-peel: apply %peel.
    ::
    ++  ap-peel
      |=  [=mark =path]
      ^+  ap-state
      ::
      =.  required-trans.sat  (~(put by required-trans.sat) ost mark)
      ::
      (ap-peer path)
    ::
    ::  +ap-peer: apply %peer.
    ::
    ++  ap-peer
      ~/  %ap-peer
      |=  pax=path
      ^+  ap-state
      ::
      =/  incoming  [attributing.routes.pry pax]
      ::
      =.  incoming.subscribers.sat
        (~(put by incoming.subscribers.sat) ost incoming)
      ::
      =^  maybe-arm  ap-state  (ap-find %peer pax)
      ::
      ?~  maybe-arm
        ap-state
      ::
      =/  arm  u.maybe-arm
      =/  =vase  !>((slag p.arm pax))
      =/  old  zip
      ::
      =.  zip  ~
      =^  maybe-tang  ap-state  (ap-call q.arm vase)
      ::
      =/  internal-moves=(list internal-move)
        =/  move  [ost %give %reap maybe-tang]
        [move old]
      ::
      =.  zip  (weld zip internal-moves)
      ::
      ?^  maybe-tang
        ap-pule
      ap-state
    ::
    ::  +ap-poke: apply %poke.
    ::
    ++  ap-poke
      ~/  %ap-poke
      |=  =cage
      ^+  ap-state
      ::
      =^  maybe-arm  ap-state  (ap-find %poke p.cage ~)
      ::
      ?~  maybe-arm
        =/  =tang  (ap-suck "no poke arm for {(trip p.cage)}")
        (ap-give %coup (some tang))
      ::
      =/  arm  u.maybe-arm
      ::
      =/  =vase
        =/  vas  (ap-term %tas p.cage)
        ?.  =(0 p.arm)
          q.cage
        (slop vas q.cage)
      ::
      =^  tur  ap-state  (ap-call q.arm vase)
      (ap-give %coup tur)
    ::
    ::  +ap-lame: pour error.
    ::
    ++  ap-lame
      |=  [=term =tang]
      ^+  ap-state
      ::
      =^  maybe-arm  ap-state  (ap-find /lame)
      ::
      =/  form  |=(=tank [%rose [~ "! " ~] tank ~])
      ::
      ?~  maybe-arm
        =/  tang  [>%ap-lame dap term< (turn tang form)]
        ~>  %slog.`rose+["  " "[" "]"]^(flop tang)
        ap-state
      ::
      =/  arm  u.maybe-arm
      =/  =vase  !>([term tang])
      ::
      =^  maybe-tang  ap-state  (ap-call q.arm vase)
      ::
      ?^  maybe-tang
        =/  tang  u.maybe-tang
        =/  etc  (flop [>%ap-lame-lame< (turn tang form)])
        ~>  %slog.`rose+["  " "[" "]"]^(welp etc [%leaf "." (flop tang)])
        ap-state
      ::
      ap-state
    ::
    ::  +ap-misvale: broken vale.
    ::
    ++  ap-misvale
      |=  =wire
      ^+  ap-state
      ::
      ~&  [%ap-blocking-misvale wire]
      =/  misvaled  (~(put in misvale.sat) wire)
      ap-state(misvale.sat misvaled)
    ::
    ::  +ap-pour: generic take.
    ::
    ++  ap-pour
      ~/  %ap-pour
      |=  [=path =vase]
      ^+  ap-state
      ::
      ?.  &(?=([@ *] q.vase) ((sane %tas) -.q.vase))
        =/  =tang  (ap-suck "pour: malformed card")
        (ap-lame %pour tang)
      ::
      =/  =term  -.q.vase
      ::
      =^  maybe-arm  ap-state  (ap-find [term path])
      ::
      ?~  maybe-arm
        =/  =tang  (ap-suck "pour: no {(trip -.q.vase)}: {<path>}")
        (ap-lame term tang)
      ::
      =/  arm  u.maybe-arm
      ::
      =^  at-slot  cache.sat  (~(slot wa cache.sat) 3 vase)
      ::
      =/  vase  (slop !>((slag p.arm path)) at-slot)
      ::
      =^  maybe-tang  ap-state  (ap-call q.arm vase)
      ::
      ?^  maybe-tang
        (ap-lame term u.maybe-tang)
      ap-state
    ::
    ::  +ap-purr: unwrap take.
    ::
    ++  ap-purr
      ~/  %ap-purr
      |=  [=term pax=path =cage]
      ^+  ap-state
      ::
      =^  maybe-arm  ap-state  (ap-find [term p.cage pax])
      ::
      ?~  maybe-arm
        =/  =tang  (ap-suck "{(trip term)}: no {<`path`[p.cage pax]>}")
        (ap-lame term tang)
      ::
      =/  arm  u.maybe-arm
      ::
      =/  =vase
        %-  slop
        ?:  =(0 p.arm)
          [!>(`path`pax) !>(cage)]
        [!>((slag (dec p.arm) `path`pax)) q.cage]
      ::
      =^  maybe-tang  ap-state  (ap-call q.arm vase)
      ::
      ?^  maybe-tang
        (ap-lame q.arm u.maybe-tang)
      ap-state
    ::
    ::  +ap-pout: specific take.
    ::
    ++  ap-pout
      |=  [=path =internal-gift]
      ^+  ap-state
      ::
      ?-  -.internal-gift
        %coup  (ap-take %coup +.path (some !>(p.internal-gift)))
        %diff  (ap-diff attributing.routes.pry path p.internal-gift)
        %quit  (ap-take %quit +.path ~)
        %reap  (ap-take %reap +.path (some !>(p.internal-gift)))
      ==
    ::
    ::  +ap-prep: install.
    ::
    ++  ap-prep
      |=  maybe-vase=(unit vase)
      ^-  [(unit tang) _ap-state]
      ::
      =^  maybe-tang  ap-state  (ap-prop maybe-vase)
      ::
      :-  maybe-tang
      :: FIXME
      %=    ap-state
          misvale.sat
        ~?  !=(misvale.sat *misvale-data)  misvale-drop+misvale.sat
        *misvale-data                 ::  new app might mean new marks
      ::
          find-cache.sat
        ~
      ::
          dub
        :_(dub ?~(maybe-tang [%& dap ?~(maybe-vase %boot %bump) now] [%| u.maybe-tang]))
      ==
    ::
    ::  +ap-prop: install.
    ::
    ++  ap-prop
      ~/  %ap-prop
      |=  vux=(unit vase)
      ^-  [(unit tang) _ap-state]
      ::
      ?.  (ap-fond %prep)
        ?~  vux
          (some ap-state)
        ::
        =+  [new=p:(slot 13 running-state.sat) old=p:(slot 13 u.vux)]
        ::
        ?.  (~(nest ut p:(slot 13 running-state.sat)) %| p:(slot 13 u.vux))
          =/  =tang  (ap-suck "prep mismatch")
          :_(ap-state (some tang))
        (some ap-state(+13.q.running-state.sat +13.q.u.vux))
      ::
      =^  tur  ap-state
          %+  ap-call  %prep
          ?~(vux !>(~) (slop !>(~) (slot 13 u.vux)))
      ::
      ?~  tur
        (some ap-state)
      :_(ap-state (some u.tur))
    ::
    ::  +ap-pule: silent delete.
    ::
    ++  ap-pule
      ^+  ap-state
      ::
      =/  incoming  (~(get by incoming.subscribers.sat) ost)
      ?~  incoming
        ap-state
      ::
      %_  ap-state
        incoming.subscribers.sat  (~(del by incoming.subscribers.sat) ost)
        meter.subscribers.sat  (~(del by meter.subscribers.sat) ost)
      ==
    ::
    ::  +ap-pull: load delete.
    ::
    ++  ap-pull
      ^+  ap-state
      ::
      =/  maybe-incoming  (~(get by incoming.subscribers.sat) ost)
      ?~  maybe-incoming
        ap-state
      ::
      =/  incoming  u.maybe-incoming
      ::
      =:  incoming.subscribers.sat  (~(del by incoming.subscribers.sat) ost)
          meter.subscribers.sat     (~(del by meter.subscribers.sat) ost)
      ==
      ::
      =^  maybe-arm  ap-state  (ap-find %pull q.incoming)
      ::
      ?~  maybe-arm
        ap-state
      ::
      =/  arm  u.maybe-arm
      ::
      =^  cam  ap-state
        %+  ap-call  q.arm
        !>((slag p.arm q.incoming))
      ::
      ?^  cam
        (ap-lame q.arm u.cam)
      ap-state
    ::
    ::  +ap-kill: queue kill.
    ::
    ++  ap-kill
      ^+  ap-state
      (ap-give:ap-pull %quit ~)
    ::
    ::  +ap-take: non-diff gall take.
    ::
    ++  ap-take
      ~/  %ap-take
      |=  [=term =path vux=(unit vase)]
      ^+  ap-state
      ::
      =^  maybe-arm  ap-state  (ap-find term path)
      ::
      ?~  maybe-arm
        ap-state
      ::
      =/  arm  u.maybe-arm
      ::
      =^  cam  ap-state
        %+  ap-call  q.arm
        =+  den=!>((slag p.arm path))
        ?~(vux den (slop den u.vux))
      ::
      ?^  cam
        (ap-lame q.arm u.cam)
      ap-state
    ::
    ::  +ap-safe: process move list.
    ::
    ++  ap-safe
      ~/  %ap-safe
      |=  =vase
      ^-  [(each (list internal-move) tang) _ap-state]
      ::
      ?~  q.vase
        [[%.y p=~] ap-state]
      ::
      ?@  q.vase
        =/  =tang  (ap-suck "move: malformed list")
        [[%.n tang] ap-state]
      ::
      =^  hed  cache.sat  (~(slot wa cache.sat) 2 vase)
      =^  sud  ap-state  (ap-move hed)
      ::
      ?:  ?=(%.n -.sud)
        [sud ap-state]
      ::
      =^  tel  cache.sat  (~(slot wa cache.sat) 3 vase)
      =^  res  ap-state  $(vase tel)
      ::
      =/  possibly-internal-moves
        ?:  ?=(%.n -.res)
          res
        [%.y p.sud p.res]
      ::
      [possibly-internal-moves ap-state]
    ::
    ::  +ap-sake: handle result.
    ::
    ++  ap-sake
      ~/  %ap-sake
      |=  =vase
      ^-  [(unit tang) _ap-state]
      ::
      ?:  ?=(@ q.vase)
        =/  =tang  (ap-suck "sake: invalid product (atom)")
        [(some tang) ap-state]
      ::
      =^  hed  cache.sat  (~(slot wa cache.sat) 2 vase)
      =^  muz  ap-state  (ap-safe hed)
      ::
      ?:  ?=(%.n -.muz)
        [(some p.muz) ap-state]
      ::
      =^  tel  cache.sat  (~(slot wa cache.sat) 3 vase)
      =^  sav  ap-state  (ap-save tel)
      ::
      ?:  ?=(%.n -.sav)
        [(some p.sav) ap-state]
      ::
      :-  ~
      %_  ap-state
        zip                (weld (flop p.muz) zip)
        running-state.sat  p.sav
      ==
    ::
    ::  +ap-save: verify core.
    ::
    ++  ap-save
      ~/  %ap-save
      |=  vax=vase
      ^-  [(each vase tang) _ap-state]
      ::
      =^  gud  cache.sat  (~(nest wa cache.sat) p.running-state.sat p.vax)
      ::
      :_  ap-state
      ?.  gud
        =/  =tang  (ap-suck "invalid core")
        [%.n tang]
      [%.y vax]
    ::
    ::  +ap-slam: virtual slam.
    ::
    ++  ap-slam
      ~/  %ap-slam
      |=  [cog=term gat=vase arg=vase]
      ^-  [(each vase tang) _ap-state]
      ::
      =/  wyz
        %-  mule  |.
        (~(mint wa cache.sat) [%cell p.gat p.arg] [%cnsg [%$ ~] [%$ 2] [%$ 3] ~])
      ::
      ?:  ?=(%.n -.wyz)
        %-  =/  sam  (~(peek ut p.gat) %free 6)
            (slog >%ap-slam-mismatch< ~(duck ut p.arg) ~(duck ut sam) ~)
        =/  =tang  (ap-suck "call: {<cog>}: type mismatch")
        [[%.n tang] ap-state]
      ::
      :_  ap-state(cache.sat +>.wyz)
      =+  [typ nok]=+<.wyz
      =/  ton  (mock [[q.gat q.arg] nok] ap-sled)
      ?-  -.ton
        %0  [%.y typ p.ton]
        %1  [%.n (turn p.ton |=(a/* (smyt (path a))))]
        %2  [%.n p.ton]
      ==
    ::
    ::  +ap-sled: namespace view.
    ::
    ++  ap-sled  (sloy ska)
    ::
    ::  +ap-suck: standard tang.
    ::
    ++  ap-suck
      |=  =tape
      ^-  tang
      ::
      =/  =tank  [%leaf (weld "gall: {<dap>}: " tape)]
      [tank ~]
    ::
    ::  +ap-term: atomic vase.
    ::
    ++  ap-term
      |=  [=term =atom]
      ^-  vase
      ::
      =/  =type  [%atom term (some atom)]
      [p=type q=atom]
    ::
    ::  +ap-vain: card to vane.
    ::
    ++  ap-vain
      |=  =term
      ^-  (unit @tas)
      ::
      ?+  term  ~&  [%ap-vain term]
               ~
        %bonk   `%a
        %build  `%f
        %cash   `%a
        %conf   `%g
        %cred   `%c
        %crew   `%c
        %crow   `%c
        %deal   `%g
        %dirk   `%c
        %drop   `%c
        %flog   `%d
        %info   `%c
        %keep   `%f
        %kill   `%f
        %look   `%j
        %merg   `%c
        %mint   `%j
        %mont   `%c
        %nuke   `%a
        %ogre   `%c
        %perm   `%c
        %rest   `%b
        %rule   `%e
        %serv   `%e
        %snap   `%j
        %them   `%e
        %wait   `%b
        %want   `%a
        %warp   `%c
        %well   `%e
        %well   `%e
        %wind   `%j
        %wipe   `%f
      ==
    --
  --
::
::  +call: request.
::
++  call
  ~%  %gall-call  +>   ~
  |=  [=duct hic=(hypo (hobo task:able))]
  ^-  [(list move) _gall-payload]
  ::
  =>  .(q.hic ?.(?=(%soft -.q.hic) q.hic ((hard task:able) p.q.hic)))
  ::
  =/  initialised  (mo-abed:mo duct)
  ::
  ?-    -.q.hic
      ::
      %conf
      ::
    =/  =dock  p.q.hic
    =/  =ship  p.dock
    ?.  =(our ship)
      ~&  [%gall-not-ours ship]
      [~ gall-payload]
    ::
    =/  booted  (mo-boot:initialised q.dock q.q.hic)
    mo-abet:booted
      ::
      %deal
      ::
    =<  mo-abet
    :: either to us
    ::
    ?.  =(our q.p.q.hic)
      :: or from us
      ::
      ?>  =(our p.p.q.hic)
      (mo-away:initialised q.p.q.hic q.q.hic)
    (mo-come:initialised p.p.q.hic q.q.hic)
      ::
      %init
      ::
    =/  payload  gall-payload(system-duct.ship-state.gall duct)
    [~ payload]
      ::
      %sunk
      ::
    [~ gall-payload]
      ::
      %vega
      ::
    [~ gall-payload]
      ::
      %west
      ::
    ?>  ?=([?(%ge %gh) @ ~] q.q.hic)
    =*  dap  i.t.q.q.hic
    =*  him  p.q.hic
    ::
    ?:  ?=(%ge i.q.q.hic)
      =/  mes  ((pair @ud forward-ames) r.q.hic)
      =<  mo-abet
      (mo-gawk:initialised him dap mes)
    ::
    =/  mes  ((pair @ud reverse-ames) r.q.hic)
    =<  mo-abet
    (mo-gawd:initialised him dap mes)
      ::
      %wegh
      ::
    =/  =mass
      :+  %gall  %.n
      :~  foreign+&+contacts.ship-state.gall
          :+  %blocked  %.n
          (sort ~(tap by (~(run by waiting.ship-state.gall) |=(blocked [%.y +<]))) aor)
          :+  %active   %.n
          (sort ~(tap by (~(run by running.ship-state.gall) |=(agent [%.y +<]))) aor)
          [%dot %.y gall]
      ==
    =/  =move  [duct %give %mass mass]
    [[move ~] gall-payload]
  ==
::
::  +load: recreate vane.
::
++  load
  |=  old=gall-n
  ^+  gall-payload
  ?-  -.old
    %0  gall-payload(gall old)
  ==
::
::  +scry: standard scry.
::
++  scry
  ~/  %gall-scry
  |=  [fur=(unit (set monk)) =term =shop =desk =coin =path]
  ^-  (unit (unit cage))
  ?.  ?=(%.y -.shop)
    ~
  ::
  =/  =ship  p.shop
  ::
  ?:  ?&  =(%u term)
          =(~ path)
          =([%$ %da now] coin)
          =(our ship)
      ==
    =/  =vase  !>((~(has by running.ship-state.gall) desk))
    =/  =cage  [%noun vase]
    (some (some cage))
  ::
  ?.  =(our ship)
    ~
  ::
  ?.  =([%$ %da now] coin)
    ~
  ::
  ?.  (~(has by running.ship-state.gall) desk)
    (some ~)
  ::
  ?.  ?=(^ path)
    ~
  ::
  =/  initialised  mo-abed:mo
  =/  =privilege  [%high [p=~ q=ship]]
  (mo-peek:initialised desk privilege term path)
::
::  +stay: save without cache.
::
++  stay  gall
::
::  +take: response.
::
++  take
  ~/  %gall-take
  |=  [=wire =duct hin=(hypo sign-arvo)]
  ^-  [(list move) _gall-payload]
  ::
  ~|  [%gall-take wire]
  ::
  ?>  ?=([?(%sys %use) *] wire)
  =/  initialised  (mo-abed:mo duct)
  ?-  i.wire
      ::
      %sys
      ::
    =/  syssed  (mo-cyst:initialised t.wire q.hin)
    mo-abet:syssed
      ::
      %use
      ::
    =/  cooked  (mo-cook:initialised t.wire hin)
    mo-abet:cooked
  ==
--
