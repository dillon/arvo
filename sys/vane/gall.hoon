!:  ::  %gall, agent execution
!?  163
::::
|=  pit=vase
=,  gall
=>  =~
|%  ::::::::::::::::::::::::::::::::::::::::::::::::::::::    rest of arvo
    ::::::::::::::::::::::::::::::::::::::::::::::::::::::
++  coke                                                ::  cook
  $?  %inn                                              ::
      %out                                              ::
      %cay                                              ::
  ==                                                    ::
++  volt  ?(%low %high)                                 ::  voltage
++  torc  $@(?(%iron %gold) [%lead p=ship])             ::  security control
++  roon                                                ::  reverse ames msg
  $%  [%d p=mark q=*]                                   ::  diff (diff)
      [%x ~]                                            ::
  ==                                                    ::
++  rook                                                ::  forward ames msg
  $%  [%m p=mark q=*]                                   ::  message
      [%l p=mark q=path]                                ::  "peel" subscribe
      [%s p=path]                                       ::  subscribe
      [%u ~]                                            ::  cancel+unsubscribe
  ==                                                    ::
++  whey                                                ::  foreign response
  $?  %peer                                             ::
      %peel                                             ::
      %poke                                             ::
      %pull                                             ::
  ==                                                    ::
--                                                      ::
|%  ::::::::::::::::::::::::::::::::::::::::::::::::::::::    local arvo
    ::::::::::::::::::::::::::::::::::::::::::::::::::::::
++  cote                                                ::  ++ap note
  $%  [%meta p=@tas q=vase]                             ::
      [%send p=ship q=cush]                             ::
      [%hiss p=(unit knot) q=mark r=cage]               ::
  ==                                                    ::
++  cove  (pair bone (wind cote cuft))                  ::  internal move
++  move  (pair duct (wind note-arvo gift-arvo))        ::  typed move
--                                                      ::
|%  ::::::::::::::::::::::::::::::::::::::::::::::::::::::    %gall state
    ::::::::::::::::::::::::::::::::::::::::::::::::::::::
++  axle-n  ?(axle)                                     ::  upgrade path
    ::::::::::::::::::::::::::::::::::::::::::::::::::::::  state proper
    ::::::::::::::::::::::::::::::::::::::::::::::::::::::
++  axle                                                ::  all state
  $:  %0                                                ::  state version
      =mast                                             ::  apps by ship
  ==                                                    ::
++  gest                                                ::  subscriber data
  $:  sup=bitt                                          ::  incoming subscribers
      neb=boat                                          ::  outgoing subscribers
      qel=(map bone @ud)                                ::  queue meter
  ==                                                    ::
++  mast                                                ::  ship state
  $:  mak=*                                             ::  (deprecated)
      sys=duct                                          ::  system duct
      sap=(map ship scad)                               ::  foreign contacts
      bum=(map dude seat)                               ::  running agents
      wub=(map dude sofa)                               ::  waiting queue
  ==                                                    ::
++  ffuc                                                ::  new cuff
    $:  p=(unit (set ship))                             ::  disclosing to
        q=ship                                          ::  attributed to
    ==                                                  ::
++  prey  (pair volt ffuc)                              ::  privilege
++  scad                                                ::  foreign connection
  $:  p=@ud                                             ::  index
      q=(map duct @ud)                                  ::  by duct
      r=(map @ud duct)                                  ::  by index
  ==                                                    ::
++  scar                                                ::  opaque input
  $:  p=@ud                                             ::  bone sequence
      q=(map duct bone)                                 ::  by duct
      r=(map bone duct)                                 ::  by bone
  ==                                                    ::
::                                                      ::
::  XX a hack, required to break a subscription loop    ::
::  which arises when an invalid mark crashes a diff.   ::
::  See usage in ap-misvale.                            ::
++  misvale-data  (set wire)                            ::  subscrs w/ bad marks
++  seat                                                ::  agent state
  $:  misvale=misvale-data                              ::  bad reqs
      vel=worm                                          ::  cache
      arms=(map [term path] (unit (pair @ud term)))     ::  ap-find cache
      mom=duct                                          ::  control duct
      liv=?                                             ::  unstopped
      toc=torc                                          ::  privilege
      tyc=stic                                          ::  statistics
      ged=gest                                          ::  subscribers
      hav=vase                                          ::  running state
      byk=beak                                          ::  update control
      pyl=(map bone mark)                               ::  req'd translations
      zam=scar                                          ::  opaque ducts
  ==                                                    ::
++  sofa  (qeu (trel duct prey club))                   ::  blocked kisses
++  stic                                                ::  statistics
  $:  act=@ud                                           ::  change number
      eny=@uvJ                                          ::  entropy
      lat=@da                                           ::  time
  ==                                                    ::
--                                                      ::
    ::::::::::::::::::::::::::::::::::::::::::::::::::::::  vane header
    ::::::::::::::::::::::::::::::::::::::::::::::::::::::
.  ==
=|  all=axle                                            ::  all vane state
|=  $:  our=ship                                        ::  identity
        now=@da                                         ::  urban time
        eny=@uvJ                                        ::  entropy
        ska=sley                                        ::  activate
    ==                                                  ::  opaque core
~%  %gall-top  ..is  ~
::
::  state machine
::
|%
::
::  +mo: move handling.
::
++  mo
  ~%  %gall-mo  +>  ~
  ::
  =*  mas  mast.all
  =*  bowl-type  -:!>(*bowl)
  =*  mo-context  +
  ::
  |_  $:  hen=duct
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
    ^-  [(list move) _mo-context]
    ::
    =/  resolved  (flop moves)
    [resolved mo-context]
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
    =/  =move  [hen %pass pass]
    mo-state(moves [move moves])
  ::
  ::  +mo-give: prepend a standard %give move to the move state.
  ::
  ++  mo-give
    |=  =gift:able
    ^+  mo-state
    ::
    =/  =move  [hen %give gift]
    mo-state(moves [move moves])
  ::
  :: +mo-okay: check that a vase contains a valid bowl.
  ::
  ++  mo-okay
    ~/  %mo-okay
    |=  =vase
    ^-  ?
    ::
    =/  val  (slew 12 vase)
    ?~  val
      %.n
    ::
    =/  bowl  p.u.val
    (~(nest ut bowl) %.n bowl-type)
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
    =/  app-data=(unit seat)  (~(get by bum.mas) dude)
    ?^  app-data
      ::  update the path
      ::
      =/  updated  u.app-data(byk beak)
      =.  bum.mas  (~(put by bum.mas) dude updated)
      ::  magic update string from the old +mo-boon, "complete old boot"
      ::
      =/  =prey  [%high [~ our]]
      =/  abedded  (ap-abed:ap dude prey)
      =/  peeped  (ap-peep:abedded result-vase)
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
      =/  =prey  [%high [~ our]]
      =/  abedded  (ap-abed:ap dude prey)
      (ap-prop:abedded ~)
    ::
    ?^  -.wag
      =.  mo-state  old
      (mo-give %onto %.n u.-.wag)
    ::
    =.  mo-state  ap-abet:+.wag
    ::
    =/  clawed  (mo-claw dude)
    (mo-give:clawed %onto %.y dude %boot now)
  ::
  ::  +mo-born: create a new seat.
  ::
  ++  mo-born
    |=  [=dude =beak =vase]
    ^+  mo-state
    ::
    =|  =seat
    ::
    =/  =scar
      =/  bone  1
      =/  bone-duct  [[[~ ~] 0] ~ ~]
      =/  duct-bone  [[0 [~ ~]] ~ ~]
      [p=bone q=bone-duct r=duct-bone]
    ::
    =/  new-seat
      %_  seat
        mom  hen
        byk  beak
        hav  vase
        zam  scar
      ==
    ::
    %_  mo-state
      bum.mas  (~(put by bum.mas) dude new-seat)
    ==
  ::
  :: +mo-away: handle a foreign request.
  ::
  ++  mo-away
    ~/  %mo-away
    |=  [=ship =cush]
    ^+  mo-state
    ::
    =/  =dude  p.cush
    =/  =club  q.cush
    ::
    ?:  ?=(%pump -.club)
      ::
      ::  you'd think this would send an ack for the diff
      ::  that caused this pump.  it would, but we already
      ::  sent it when we got the diff in ++mo-cyst.  then
      ::  we'd have to save the network duct and connect it
      ::  to this returning pump.
      ::
      mo-state
    ::
    ?:  ?=(%peer-not -.club)
      =/  =tang  p.club
      =/  err  (some tang)
      (mo-give %unto %reap err)
    ::
    =^  bone  mo-state  (mo-bale ship)
    ::
    =/  =rook
      ?-  -.club
        %poke  [%m p.p.club q.q.p.club]
        %pull  [%u ~]
        %puff  !!
        %punk  !!
        %peel  [%l club]
        %peer  [%s p.club]
      ==
    ::
    =/  action  -.club
    =/  =path  /sys/way/[action]
    =/  =note-arvo  [%a %want ship [%g %ge dude ~] [bone rook]]
    ::
    (mo-pass path note-arvo)
  ::
  ::  +mo-awed: handle foreign response.
  ::
  ++  mo-awed
    |=  [=whey art=(unit ares)]
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
    ?-  whey
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
    =/  =scad
      =/  default  [1 ~ ~]
      =/  existing  (~(get by sap.mas) ship)
      (fall existing default)
    ::
    =/  nom  (~(get by q.scad) hen)
    ::
    ?^  nom
      [u.nom mo-state]
    ::
    =/  index  p.scad
    ::
    =/  contacts
      %_  scad
        p  +(index)
        q  (~(put by q.scad) hen index)
        r  (~(put by r.scad) index hen)
      ==
    ::
    =/  next
      %_  mo-state
        sap.mas  (~(put by sap.mas) ship contacts)
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
    =/  conns  (~(got by sap.mas) ship)
    =/  duct  r:conns
    (~(got by duct) index)
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
      =/  ship  (slav %p i.beak-path)
      =/  desk  i.t.beak-path
      =/  case  [%da (slav %da i.t.t.beak-path)]
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
    =/  slaw  (slog (flop q.,.+>.coop)) :: kill this lark
    (slaw mo-state)
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
      ::  "XX should crash"
      =/  err  (some message.build-result)
      (mo-give %mack err)
    ::
    ::  "XX pump should ack"
    =.  mo-state  (mo-give %mack ~)
    ::
    =/  duct  (mo-ball him num)
    =/  initialised  (mo-abed duct)
    ::
    =/  =cage  (result-to-cage:ford build-result)
    =/  move  [%unto %diff cage]
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
    =/  =cuft  +>.sign-arvo
    ::
    ?-    -.cuft
        ::
        %coup
        ::
      (mo-give %mack p.cuft)
        ::
        %diff
        ::
      =/  sys-path  [%sys %red t.path]
      =/  note  [%a %want him [%g %gh dap ~] [num %d p.p.cuft q.q.p.cuft]]
      (mo-pass sys-path note)
        ::
        %quit
        ::
      =/  sys-path  [%sys path]
      =/  note  [%a %want him [%g %gh dap ~] [num %x ~]]
      (mo-pass sys-path note)
        ::
        %reap
        ::
      (mo-give %mack p.cuft)
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
    =/  him  (slav %p i.t.path)
    =/  dap  i.t.t.path
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
    =/  =prey  [%high ~ him]
    =/  =cage  (result-to-cage:ford build-result)
    =/  =club  [%poke cage]
    (mo-clip dap prey club)
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
    =/  why  ;;(whey i.t.path)
    =/  art  +>+.sign-arvo
    ::
    (mo-awed why art)
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
    =/  pap
      =/  =term  i.path
      =/  =ffuc  [~ (slav %p i.t.path)]
      =/  =prey  [%high ffuc]
      (ap-abed:ap term prey)
    ::
    =/  vax
      =/  =vase  hin
      (slot 3 vase)
    ::
    ?-  i.t.t.path
        ::
        %inn
        ::
      =/  poured  (ap-pour:pap t.t.t.path vax)
      ap-abet:poured
        ::
        %cay
        ::
      ?.  ?=([%e %sigh *] q.hin)
        ~&  [%mo-cook-weird q.hin]
        ~&  [%mo-cook-weird-path path]
        mo-state
      =/  purred  (ap-purr:pap +<.q.hin t.t.t.path +>.q.hin)
      ap-abet:purred
        ::
        %out
        ::
      ?.  ?=([%g %unto *] q.hin)
        ~&  [%mo-cook-weird q.hin]
        ~&  [%mo-cook-weird-path path]
        mo-state
      =/  pouted  (ap-pout:pap t.t.t.path +>.q.hin)
      ap-abet:pouted
    ==
  ::
  ::  +mo-claw: clear queue.
  ::
  ++  mo-claw
    |=  =dude
    ^+  mo-state
    ::
    ?.  (~(has by bum.mas) dude)
      mo-state
    ::
    =/  maybe-sofa  (~(get by wub.mas) dude)
    ::
    ?~  maybe-sofa
      mo-state
    ::
    =/  =sofa  u.maybe-sofa
    ::
    |-
    ^+  mo-state
    ?:  =(~ sofa)
      %_  mo-state
        wub.mas  (~(del by wub.mas) dude)
      ==
    ::
    =^  cushion  sofa  [p q]:~(get to sofa)
    =/  =duct  p.cushion
    =/  =prey  q.cushion
    =/  =club  r.cushion
    ::
    =/  move  [duct %slip %g %deal [q.q.prey our] dude club]
    $(moves [move moves])
  ::
  ::  +mo-beak: build beak.
  ::
  ++  mo-beak
    |=  =dude
    ^-  beak
    ::
    =/  =beak
      =/  mast  (~(got by bum.mas) dude)
      byk:mast
    ::
    ?.  =(p.beak our)
      beak
    beak(r [%da now])
  ::
  ::  +mo-peek: scry.
  ::
  ++  mo-peek
    ~/  %mo-peek
    |=  [=dude =prey =term =path]
    ^-  (unit (unit cage))
    ::
    =/  pap  (ap-abed:ap dude prey)
    (ap-peek:pap term path)
  ::
  ::  +mo-clip: apply club.
  ::
  ++  mo-clip
    |=  [=dude =prey =club]
    ^+  mo-state
    ::
    =/  =path
      =/  ship  (scot %p q.q.prey)
      /sys/val/[ship]/[dude]
    ::
    =/  ship-info
      =/  beak  (mo-beak dude)
      [p q]:beak
    ::
    ?:  ?=(%puff -.club)
      =/  =schematic:ford  [%vale ship-info +.club]
      =/  =note-arvo  [%f %build live=%.n schematic]
      (mo-pass path note-arvo)
    ::
    ?:  ?=(%punk -.club)
      =/  =schematic:ford  [%cast ship-info p.club [%$ q.club]]
      =/  =note-arvo  [%f %build live=%.n schematic]
      (mo-pass path note-arvo)
    ::
    ?:  ?=(%peer-not -.club)
      =/  err  (some p.club)
      (mo-give %unto %reap err)
    ::
    =/  pap  (ap-abed:ap dude prey)
    =/  clubbed  (ap-club:pap club)
    ap-abet:clubbed
  ::
  ::  +mo-come: handle locally.
  ::
  ++  mo-come
    |=  [=ship =cush]
    ^+  mo-state
    ::
    =/  default-sofa  *sofa
    ::
    =/  =prey  [%high [~ ship]]
    =/  =dude  p.cush
    =/  =club  q.cush
    ::
    =/  is-running  (~(has by bum.mas) dude)
    =/  is-waiting  (~(has by wub.mas) dude)
    ::
    ?:  |(!is-running is-waiting)
      ~&  >>  [%mo-not-running dude -.club] :: FIXME remove?
      ::
      =/  =sofa
        =/  waiting  (~(get by wub.mas) dude)
        =/  kisses  (fall waiting default-sofa)
        =/  kiss  [hen prey club]
        (~(put to kisses) kiss)
      ::
      %_  mo-state
        wub.mas  (~(put by wub.mas) dude sofa)
      ==
    ::
    (mo-clip dude prey club)
  ::
  ::  +mo-gawk: ames forward.
  ::
  ++  mo-gawk
    |=  [=ship =dude =bone =rook]
    ^+  mo-state
    ::
    =.  mo-state
      ?.  ?=(%u -.rook)
        mo-state
      (mo-give %mack ~)
    ::
    =/  =path
      =/  him  (scot %p ship)
      =/  num  (scot %ud bone)
      /sys/req/[him]/[dude]/[num]
    ::
    =/  =note-arvo
      ?-  -.rook
        %m  [%g %deal [ship our] dude %puff p.rook q.rook]
        %l  [%g %deal [ship our] dude %peel p.rook q.rook]
        %s  [%g %deal [ship our] dude %peer p.rook]
        %u  [%g %deal [ship our] dude %pull ~]
      ==
    ::
    (mo-pass path note-arvo)
  ::
  ::  +mo-gawd: ames backward.
  ::
  ++  mo-gawd
    |=  [=ship =dude =bone =roon]
    ^+  mo-state
    ::
    ?-    -.roon
        ::
        %d
      =/  =path
        =/  him  (scot %p ship)
        =/  num  (scot %ud bone)
        /sys/rep/[him]/[dude]/[num]
      ::
      =/  =note-arvo
        =/  beak  (mo-beak dude)
        =/  info  [p q]:beak
        =/  =schematic:ford  [%vale info p.roon q.roon]
        [%f %build live=%.n schematic]
      ::
      (mo-pass path note-arvo)
        ::
        %x
      ::  XX should crash
      =.  mo-state  (mo-give %mack ~)
      ::
      =/  out  (mo-ball ship bone)
      =/  abedded  (mo-abed out)
      (mo-give:abedded %unto %quit ~)
    ==
  ::
  ::  +ap: agent engine
  ::
  ++  ap
    ~%  %gall-ap  +>  ~
    ::
    |_  $:  dap=dude
            pry=prey
            ost=bone
            zip=(list cove)
            dub=(list (each suss tang))
            sat=seat
        ==
    ::
    ++  ap-state  .
    ::
    ::  +ap-abed: initialise the provided app with the supplied privilege.
    ::
    ++  ap-abed
      ~/  %ap-abed
      |=  [=dude =prey]
      ^+  ap-state
      ::
      =/  =seat
        =/  sitting  (~(got by bum.mas) dude)
        =/  =stic
          =/  stat  tyc.sitting
          =/  nact  +(act.stat)
          =/  trop  (shaz (mix (add dude nact) eny))
          [act=nact eny=trop lat=now]
        sitting(tyc stic)
      ::
      =/  bone  p.zam.seat
      =/  bone-duct  q.zam.seat
      =/  duct-bone  r.zam.seat
      ::
      =/  maybe-bone  (~(get by bone-duct) hen)
      ::
      ?^  maybe-bone
        =/  bone  u.maybe-bone
        ap-state(dap dude, pry prey, sat seat, ost bone)
      ::
      =/  =scar
        =/  bone  +(bone)
        =/  bone-duct  (~(put by bone-duct) hen bone)
        =/  duct-bone  (~(put by duct-bone) bone hen)
        [p=bone q=bone-duct r=duct-bone]
      ::
      %=  ap-state
        ost      bone
        zam.sat  scar
      ==
    ::
    ::  +ap-abet: resolve moves.
    ::
    ++  ap-abet
      ^+  mo-state
      ::
      =>  ap-abut
      %_  mo-state
        bum.mas  (~(put by bum.mas) dap sat)
        moves  :(weld (turn zip ap-aver) (turn dub ap-avid) moves)
      ==
    ::
    ::  +ap-abut: track queue.
    ::
    ++  ap-abut
      ^+  ap-state
      ::
      =/  coves  zip
      =/  bones  *(set bone)
      ::
      |-  ^+  ap-state
      ?^  coves
        ?.  ?=([%give %diff *] q.i.coves)
          $(coves t.coves)
        ::
        =^  added  ap-state  ap-fill(ost p.i.coves)
        ::
        =/  ribs
          ?:  added
            bones
          (~(put in bones) p.i.coves)
        ::
        $(coves t.coves, bones ribs)
      ::
      =/  boned  ~(tap in bones)
      ::
      |-  ^+  ap-state
      ?~  boned
        ap-state
      =>  %*(. $(boned t.boned) ost i.boned) :: FIXME
      ::
      =/  tib  (~(get by sup.ged.sat) ost)
      ::
      ?~  tib
        ~&  [%ap-abut-bad-bone dap ost]
        ..ap-kill
      ap-kill(q.q.pry p.u.tib)
    ::
    ::  +ap-aver: cove to move.
    ::
    ++  ap-aver
      ~/  %ap-aver
      |=  =cove
      ^-  move
      ::
      :-  (~(got by r.zam.sat) p.cove)
      ?-    -.q.cove
          ::
          %slip  !!
          ::
          %sick  !!
          ::
          %give
          ::
        ?<  =(0 p.cove)
        ?.  ?=(%diff -.p.q.cove)
          [%give %unto p.q.cove]
        ::
        =/  =cage  p.p.q.cove
        =/  =mark  (fall (~(get by pyl.sat) p.cove) p.cage)
        ::
        ?:  =(mark p.cage)
          [%give %unto p.q.cove]
        ::
        =/  =path  /sys/pel/[dap]
        =/  =schematic:ford
          =/  =beak  (mo-beak dap)
          [%cast [p q]:beak mark [%$ cage]]
        ::
        =/  =note-arvo  [%f %build live=%.n schematic]
        [%pass path note-arvo]
          ::
          %pass
          ::
        =/  =path  [%use dap p.q.cove]
        =/  =note-arvo
          ?-  -.q.q.cove
              %hiss
            [%e %hiss +.q.q.cove]
              ::
              %send
            =/  =sock  [our p.q.q.cove]
            =/  =cush  [q.q.q.cove]
            [%g %deal sock cush]
              ::
              %meta
            =/  =term  p.q.q.cove
            =/  =vase  q.q.q.cove
            [term %meta vase]
          ==
        [%pass path note-arvo]
      ==
    ::
    ::  +ap-avid: onto results.
    ::
    ++  ap-avid
      |=  a=(each suss tang)
      ^-  move
      ::
      [hen %give %onto a]
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
      ?:  ?=(%| -.arm)
        [(some p.arm) ap-state]
      ::
      =^  zem  ap-state  (ap-slam term p.arm vase)
      ::
      ?:  ?=(%| -.zem)
        [(some p.zem) ap-state]
      (ap-sake p.zem)
    ::
    ::  +ap-peek: peek.
    ::
    ++  ap-peek
      ~/  %ap-peek
      |=  [ren=@tas tyl=path]
      ^-  (unit (unit cage))
      ::
      =+
        ?.  ?=(%x ren)
          [mark=%$ tyl=tyl]
        =/  =path  (flop tyl)
        ?>  ?=(^ path)
        [mark=i.path tyl=(flop t.path)]
      ::
      =^  cug  ap-state  (ap-find %peek ren tyl)
      ::
      ?~  cug
        =/  =tank  [%leaf "peek find fail"]
        ((slog tank >tyl< >mark< ~) [~ ~])
      ::
      =^  arm  ap-state  (ap-farm q.u.cug)
      ::
      ?:  ?=(%| -.arm)
        =/  =tank  [%leaf "peek farm fail"]
        ((slog tank p.arm) [~ ~])
      ::
      =/  slammed
        =/  =path  [ren tyl]
        =/  =vase  !>((slag p.u.cug path))
        (ap-slam q.u.cug p.arm vase)
      ::
      =^  zem  ap-state  slammed
      ::
      ?:  ?=(%| -.zem)
        =/  =tank  [%leaf "peek slam fail"]
        ((slog tank p.zem) [~ ~])
      ::
      =/  err
        =/  =tank  [%leaf "peek bad result"]
        ((slog tank ~) [~ ~])
      ::
      ?+  q.p.zem  err
          ~              ~
       ::
          [~ ~]         [~ ~]
       ::
          [~ ~ ^]
        =/  =vase  (sped (slot 7 p.zem))
        ::
        ?.  ?=([p=@ *] q.vase)
          =/  =tank  [%leaf "scry: malformed cage"]
          ((slog tank ~) [~ ~])
        ::
        ?.  ((sane %as) p.q.vase)
          =/  =tank  [%leaf "scry: malformed cage"]
          ((slog tank ~) [~ ~])
        ::
        ?.  =(mark p.q.vase)
          [~ ~]
        ::
        =/  =cage  [p.q.vase (slot 3 vase)]
        (some (some cage))
      ==
    ::
    ::  +ap-club: apply effect.
    ::
    ++  ap-club
      |=  =club
      ^+  ap-state
      ::
      ?-  -.club
        %peel       (ap-peel +.club)
        %poke       (ap-poke +.club)
        %peer       (ap-peer +.club)
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
      |=  [=ship pax=path =cage]
      ^+  ap-state
      ::
      =/  diff  [%diff p.cage +.pax]
      ::
      =^  cug  ap-state  (ap-find diff)
      ::
      ?~  cug
        =/  target  [%.n ship +.pax]
        ::
        =/  suck
          =/  why  "diff: no {<`path`[p.cage +.pax]>}"
          (ap-suck why)
        ::
        =/  lame  (ap-lame %diff suck)
        (ap-pump:lame target)
      ::
      =/  =vase
        =/  target
          ?:  =(0 p.u.cug)
            [!>(`path`+.pax) !>(cage)]
          [!>((slag (dec p.u.cug) `path`+.pax)) q.cage]
        (slop target)
      ::
      =^  cam  ap-state  (ap-call q.u.cug vase)
      ::
      ?^  cam
        =/  lame  (ap-lame q.u.cug u.cam)
        (ap-pump:lame %.n ship pax)
      (ap-pump %.y ship pax)
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
        (ap-pass way %send ship -.path %pump ~)
      ::
      =/  give  (ap-give %quit ~)
      (ap-pass:give way %send ship -.path %pull ~)
    ::
    ::  +ap-fail: drop from queue.
    ::
    ++  ap-fall
      ^+  ap-state
      ::
      ?.  (~(has by sup.ged.sat) ost)
        .
      ::
      =/  soy  (~(get by qel.ged.sat) ost)
      ::
      ?:  |(?=(~ soy) =(0 u.soy))
        + :: FIXME
      ::
      =.  u.soy  (dec u.soy)
      ::
      ?:  =(0 u.soy)
        +(qel.ged.sat (~(del by qel.ged.sat) ost))     :: FIXME
      +(qel.ged.sat (~(put by qel.ged.sat) ost u.soy)) :: FIXME
    ::
    ::  +ap-farm: produce arm.
    ::
    ++  ap-farm
      ~/  %ap-farm
      |=  =term
      ^-  [(each vase tang) _ap-state]
      ::
      =/  pyz  (mule |.((~(mint wa vel.sat) p.hav.sat [%limb term]))) :: FIXME
      ::
      ?:  ?=(%.n -.pyz)
        =/  =tang  +.pyz
        =/  that  [%.n p=tang]
        [that ap-state]
      ::
      =/  that
        =/  ton  (mock [q.hav.sat q.+<.pyz] ap-sled)
        ?-  -.ton
          %0  [%& p.+<.pyz p.ton]
          %1  [%.n (turn p.ton |=(a/* (smyt (path a))))]
          %2  [%.n p.ton]
        ==
      ::
      =/  =worm  +>.pyz
      =/  next  ap-state(vel.sat worm)
      [that next]
    ::
    ::  +ap-fill: add to queue.
    ::
    ++  ap-fill
      ^-  [? _ap-state]
      ::
      :: FIXME
      =/  suy  (fall (~(get by qel.ged.sat) ost) 0)
      =/  subscriber-ship  p:(~(got by sup.ged.sat) ost)
      ::
      :: FIXME
      ?:  &(=(20 suy) !=(our subscriber-ship))
        ~&  [%gall-pulling-20 ost (~(get by sup.ged.sat) ost) (~(get by r.zam.sat) ost)]
        [%.n ..ap-fill]
      [%.y ..ap-fill(qel.ged.sat (~(put by qel.ged.sat) ost +(suy)))]
    ::
    ::  +ap-find: general arm.
    ::
    ++  ap-find
      ~/  %ap-find
      |=  [=term =path]
      ^-  [(unit (pair @ud @tas)) _ap-state]
      ::  check cache
      ::
      =/  maybe-result  (~(get by arms.sat) [term path])
      ?^  maybe-result
        [u.maybe-result ap-state]
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
      =.  arms.sat  (~(put by arms.sat) [term path] result)
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
      (slob term p.hav.sat)
    ::
    ::  +ap-give: return result.
    ::
    ++  ap-give
      |=  =cuft
      ^+  ap-state
      ::
      =/  coves  [[ost %give cuft] zip]
      ap-state(zip coves)
    ::
    ::  +ap-bowl: set up bowl.
    ::
    ++  ap-bowl
      ^+  ap-state
      :: FIXME
      %_    ap-state
          +12.q.hav.sat
        ^-   bowl
        :*  :*  our                               ::  host
                q.q.pry                           ::  guest
                dap                               ::  agent
            ==                                    ::
            :*  wex=~                             ::  outgoing
                sup=sup.ged.sat                       ::  incoming
            ==                                    ::
            :*  ost=ost                           ::  cause
                act=act.tyc.sat                       ::  tick
                eny=eny.tyc.sat                       ::  nonce
                now=lat.tyc.sat                       ::  time
                byk=byk.sat                           ::  source
        ==  ==                                    ::
      ==
    ::
    ::  +ap-move: process each move.
    ::
    ++  ap-move
      ~/  %ap-move
      |=  =vase
      ^-  [(each cove tang) _ap-state]
      ::
      ?@  q.vase
        =/  that  [%.n (ap-suck "move: invalid move (atom)")]
        [that ap-state]
      ::
      ?^  -.q.vase
        =/  that  [%.n (ap-suck "move: invalid move (bone)")]
        [that ap-state]
      ::
      ?@  +.q.vase
        =/  that  [%.n (ap-suck "move: invalid move(card)")]
        [that ap-state]
      ::
      =/  hun  (~(get by r.zam.sat) -.q.vase)
      ::
      ?.  &((~(has by r.zam.sat) -.q.vase) !=(0 -.q.vase))
        ~&  [q-vase+q.vase has-by-r-zam+(~(has by r.zam.sat) -.q.vase)]
        =/  that  [%.n (ap-suck "move: invalid card (bone {<-.q.vase>})")]
        [that ap-state]
      ::
      =^  pec  vel.sat  (~(spot wa vel.sat) 3 vase)
      =^  cav  vel.sat  (~(slot wa vel.sat) 3 pec)
      ::
      ?+  +<.q.vase
               (ap-move-pass -.q.vase +<.q.vase cav)
        %diff  (ap-move-diff -.q.vase cav)
        %hiss  (ap-move-hiss -.q.vase cav)
        %peel  (ap-move-peel -.q.vase cav)
        %peer  (ap-move-peer -.q.vase cav)
        %pull  (ap-move-pull -.q.vase cav)
        %poke  (ap-move-poke -.q.vase cav)
        %send  (ap-move-send -.q.vase cav)
        %quit  (ap-move-quit -.q.vase cav)
      ==
    ::
    ::  +ap-move-quit: give quit move.
    ::
    ++  ap-move-quit
      ~/  %quit
      |=  [=bone =vase]
      ^-  [(each cove tang) _ap-state]
      ::
      =/  that
        ?^  q.vase
          [%.n (ap-suck "quit: improper give")]
        =/  =cuft  [%quit ~]
        =/  =cove  [bone %give cuft]
        [%.y cove]
      ::
      =/  next  ap-state(sup.ged.sat (~(del by sup.ged.sat) bone))
      ::
      [that next]
    ::
    ::  +ap-move-diff: give diff move.
    ::
    ++  ap-move-diff
      ~/  %diff
      |=  [=bone =vase]
      ^-  [(each cove tang) _ap-state]
      ::
      =^  pec  vel.sat  (~(sped wa vel.sat) vase)
      ::
      ?.  &(?=(^ q.pec) ?=(@ -.q.pec) ((sane %tas) -.q.pec)) :: FIXME
        =/  that  [%.n (ap-suck "diff: improper give")]
        [that ap-state]
      ::
      =^  tel  vel.sat  (~(slot wa vel.sat) 3 pec)
      ::
      =/  that
        =/  =cage  [-.q.pec tel]
        [%.y bone %give %diff cage]
      ::
      [that ap-state]
    ::
    ::  +ap-move-hiss: pass %hiss.
    ::
    ++  ap-move-hiss
      ~/  %hiss
      |=  [=bone =vase]
      ^-  [(each cove tang) _ap-state]
      ::
      ?.  &(?=([p=* q=* r=@ s=[p=@ *]] q.vase) ((sane %tas) r.q.vase))
        =+  args="[%hiss wire (unit knot) mark cage]"
        :_(ap-state [%| (ap-suck "hiss: bad hiss ask.{args}")])
      =^  gaw  vel.sat  (~(slot wa vel.sat) 15 vase)
      ?.  &(?=([p=@ *] q.gaw) ((sane %tas) p.q.gaw))
        :_(ap-state [%| (ap-suck "hiss: malformed cage")])
      =^  paw  vel.sat  (~(stop wa vel.sat) 3 gaw)
      =+  usr=((soft (unit knot)) q.q.vase)
      ?.  &(?=(^ usr) ?~(u.usr & ((sane %ta) u.u.usr)))
        :_(ap-state [%| (ap-suck "hiss: malformed (unit knot)")])
      =+  pux=((soft path) p.q.vase)
      ?.  &(?=(^ pux) (levy u.pux (sane %ta)))
        :_(ap-state [%| (ap-suck "hiss: malformed path")])
      :_  ap-state
      :^  %&  bone  %pass
      :-  [(scot %p q.q.pry) %cay u.pux]
      ~!  *cote
      =-  ~!  -  `cote`-
      [%hiss u.usr r.q.vase [p.q.gaw paw]]
    ::
    ::  +ap-move-mess: extract path, target.
    ::
    ++  ap-move-mess
      ~/  %mess
      |=  vax=vase
      ^-  [(each (trel path ship term) tang) _ap-state]
      ::
      :_  ap-state
      ?.  ?&  ?=([p=* [q=@ r=@] s=*] q.vax)
              (gte 1 (met 7 q.q.vax))
          ==
        [%| (ap-suck "mess: malformed target")]
      =+  pux=((soft path) p.q.vax)
      ?.  &(?=(^ pux) (levy u.pux (sane %ta)))
        [%| (ap-suck "mess: malformed path")]
      [%& [(scot %p q.q.vax) %out r.q.vax u.pux] q.q.vax r.q.vax]
    ::
    ::  +ap-move-pass: pass general move.
    ::
    ++  ap-move-pass
      ~/  %pass
      |=  [sto=bone wut=* vax=vase]
      ^-  [(each cove tang) _ap-state]
      ::
      ?.  &(?=(@ wut) ((sane %tas) wut))
        :_(ap-state [%| (ap-suck "pass: malformed card")])
      =+  pux=((soft path) -.q.vax)
      ?.  &(?=(^ pux) (levy u.pux (sane %ta)))
        :_(ap-state [%| (ap-suck "pass: malformed path")])
      =+  huj=(ap-vain wut)
      ?~  huj  :_(ap-state [%| (ap-suck "move: unknown note {(trip wut)}")])
      =^  tel  vel.sat  (~(slot wa vel.sat) 3 vax)
      :_  ap-state
      :^  %&  sto  %pass
      :-  [(scot %p q.q.pry) %inn u.pux]
      [%meta u.huj (slop (ap-term %tas wut) tel)]
    ::
    ::  +ap-move-poke: pass %poke.
    ::
    ++  ap-move-poke
      ~/  %poke
      |=  [sto=bone vax=vase]
      ^-  [(each cove tang) _ap-state]
      ::
      =^  yep  ap-state  (ap-move-mess vax)
      ?:  ?=(%| -.yep)  :_(ap-state yep)
      =^  gaw  vel.sat  (~(slot wa vel.sat) 7 vax)
      ?.  &(?=([p=@ q=*] q.gaw) ((sane %tas) p.q.gaw))
        :_(ap-state [%| (ap-suck "poke: malformed cage")])
      =^  paw  vel.sat  (~(stop wa vel.sat) 3 gaw)
      :_  ap-state
      :^  %&  sto  %pass
      :-  p.p.yep
      [%send q.p.yep r.p.yep %poke p.q.gaw paw]
    ::
    ::  +ap-move-peel: pass %peel.
    ::
    ++  ap-move-peel
      ~/  %peel
      |=  [sto=bone vax=vase]
      ^-  [(each cove tang) _ap-state]
      ::
      =^  yep  ap-state  (ap-move-mess vax)
      :_  ap-state
      ?:  ?=(%| -.yep)  yep
      =+  mar=((soft mark) +>-.q.vax)
      ?~  mar
        [%| (ap-suck "peel: malformed mark")]
      =+  pux=((soft path) +>+.q.vax)
      ?.  &(?=(^ pux) (levy u.pux (sane %ta)))
        [%| (ap-suck "peel: malformed path")]
      ?:  (~(has in misvale.sat) p.p.yep)
        =/  err  [leaf+"peel: misvalidation encountered"]~
        :^  %&  sto  %pass
        :-  p.p.yep
        [%send q.p.yep r.p.yep %peer-not err]
      :^  %&  sto  %pass
      :-  p.p.yep
      [%send q.p.yep r.p.yep %peel u.mar u.pux]
    ::
    ::  +ap-move-peer: pass %peer.
    ::
    ++  ap-move-peer
      ~/  %peer
      |=  [sto=bone vax=vase]
      ^-  [(each cove tang) _ap-state]
      ::
      =^  yep  ap-state  (ap-move-mess vax)
      :_  ap-state
      ?:  ?=(%| -.yep)  yep
      =+  pux=((soft path) +>.q.vax)
      ?.  &(?=(^ pux) (levy u.pux (sane %ta)))
        [%| (ap-suck "peer: malformed path")]
      ?:  (~(has in misvale.sat) p.p.yep)
        =/  err  [leaf+"peer: misvalidation encountered"]~
        :^  %&  sto  %pass
        :-  p.p.yep
        [%send q.p.yep r.p.yep %peer-not err]
      :^  %&  sto  %pass
      :-  p.p.yep
      [%send q.p.yep r.p.yep %peer u.pux]
    ::
    ::  +ap-move-pull: pass %pull.
    ::
    ++  ap-move-pull
      ~/  %pull
      |=  [sto=bone vax=vase]
      ^-  [(each cove tang) _ap-state]
      ::
      =^  yep  ap-state  (ap-move-mess vax)
      :_  ap-state
      ?:  ?=(%| -.yep)  yep
      ?.  =(~ +>.q.vax)
        [%| (ap-suck "pull: malformed card")]
      :^  %&  sto  %pass
      :-  p.p.yep
      [%send q.p.yep r.p.yep %pull ~]
    ::
    ::  +ap-move-send: pass gall action.
    ::
    ++  ap-move-send
      ~/  %send
      |=  [sto=bone vax=vase]
      ^-  [(each cove tang) _ap-state]
      ::
      ?.  ?&  ?=([p=* [q=@ r=@] [s=@ t=*]] q.vax)
              (gte 1 (met 7 q.q.vax))
              ((sane %tas) r.q.vax)
          ==
        :_(ap-state [%| (ap-suck "send: improper ask.[%send wire gill club]")])
      =+  pux=((soft path) p.q.vax)
      ?.  &(?=(^ pux) (levy u.pux (sane %ta)))
        :_(ap-state [%| (ap-suck "send: malformed path")])
      ?:  ?=($poke s.q.vax)
        =^  gav  vel.sat  (~(spot wa vel.sat) 7 vax)
        ?>  =(%poke -.q.gav)
        ?.  ?&  ?=([p=@ q=*] t.q.vax)
                ((sane %tas) p.t.q.vax)
            ==
          :_(ap-state [%| (ap-suck "send: malformed poke")])
        =^  vig  vel.sat  (~(spot wa vel.sat) 3 gav)
        =^  geb  vel.sat  (~(slot wa vel.sat) 3 vig)
        :_  ap-state
        :^  %&  sto  %pass
        :-  [(scot %p q.q.vax) %out r.q.vax u.pux]
        ^-  cote
        ::  ~&  [%ap-move-send `path`[(scot %p q.q.vax) %out r.q.vax u.pux]]
        [%send q.q.vax r.q.vax %poke p.t.q.vax geb]
      :_  ap-state
      =+  cob=((soft club) [s t]:q.vax)
      ?~  cob
        [%| (ap-suck "send: malformed club")]
      :^  %&  sto  %pass
      :-  [(scot %p q.q.vax) %out r.q.vax u.pux]
      ::  ~&  [%ap-move-send `path`[(scot %p q.q.vax) %out r.q.vax u.pux]]
      [%send q.q.vax r.q.vax u.cob]
    ::
    ::  +ap-pass: request action.
    ::
    ++  ap-pass
      |=  [=path =cote]
      ^+  ap-state
      ::
      =/  =cove  [ost %pass path cote]
      ap-state(zip [cove zip])
    ::
    ::  +ap-peep: reinstall.
    ::
    ++  ap-peep
      ~/  %ap-peep
      |=  =vase
      ^+  ap-state
      ::
      =/  pep  (ap-prep(hav.sat vase) (some hav.sat))
      ?~  -.pep
        +.pep
      (ap-lame %prep-failed u.-.pep)
    ::
    ::  +ap-peel: apply %peel.
    ::
    ++  ap-peel
      |=  [=mark =path]
      ^+  ap-state
      ::
      =.  pyl.sat  (~(put by pyl.sat) ost mark)
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
      =.  sup.ged.sat  (~(put by sup.ged.sat) ost [q.q.pry pax])
      =^  cug  ap-state  (ap-find %peer pax)
      ::
      ?~  cug
        ap-state
      ::
      =/  old  zip
      ::
      =.  zip  ~
      =^  cam  ap-state
          :: FIXME
          %+  ap-call  q.u.cug
          !>(`path`(slag p.u.cug pax))
      ::
      =.  zip  (weld zip `(list cove)`[[ost %give %reap cam] old])
      ::
      ?^  cam
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
      =^  cug  ap-state  (ap-find %poke p.cage ~)
      ::
      ?~  cug
        =/  suck  (ap-suck "no poke arm for {(trip p.cage)}")
        (ap-give %coup (some suck))
      ::
      =^  tur  ap-state
          :: FIXME
          %+  ap-call  q.u.cug
          ?.  =(0 p.u.cug)  q.cage
          (slop (ap-term %tas p.cage) q.cage)
      (ap-give %coup tur)
    ::
    ::  +ap-lame: pour error.
    ::
    ++  ap-lame
      |=  [=term =tang]
      ^+  ap-state
      ::
      =^  cug  ap-state  (ap-find /lame)
      ::
      :: FIXME
      ?~  cug
        =.  tang  [>%ap-lame dap term< (turn tang |=(a=tank rose+[~ "! " ~]^[a]~))]
        ~>  %slog.`rose+["  " "[" "]"]^(flop tang)
        ap-state
      ::
      =^  cam  ap-state
        %+  ap-call  q.u.cug
        !>([term tang])
      ::
      ?^  cam
        =.  tang  [>%ap-lame-lame< (turn u.cam |=(a/tank rose+[~ "! " ~]^[a]~))]
        ~>  %slog.`rose+["  " "[" "]"]^(welp (flop tang) leaf+"." (flop u.cam))
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
      |=  [pax=path =vase]
      ^+  ap-state
      ::
      ?.  &(?=([@ *] q.vase) ((sane %tas) -.q.vase))
        (ap-lame %pour (ap-suck "pour: malformed card"))
      ::
      =^  cug  ap-state  (ap-find [-.q.vase pax])
      ::
      ?~  cug
        =/  suck  (ap-suck "pour: no {(trip -.q.vase)}: {<pax>}")
        (ap-lame -.q.vase suck)
      ::
      =^  tel  vel.sat  (~(slot wa vel.sat) 3 vase)
      =^  cam  ap-state
          %+  ap-call  q.u.cug
          %+  slop
            !>(`path`(slag p.u.cug pax))
          tel
      ::
      ?^  cam
        (ap-lame -.q.vase u.cam)
      ap-state
    ::
    ::  +ap-purr: unwrap take.
    ::
    ++  ap-purr
      ~/  %ap-purr
      |=  [=term pax=path =cage]
      ^+  ap-state
      ::
      =^  cug  ap-state  (ap-find [term p.cage pax])
      ?~  cug
        =/  suck  (ap-suck "{(trip term)}: no {<`path`[p.cage pax]>}")
        (ap-lame term suck)
      ::
      =/  =vase
        %-  slop
        ?:  =(0 p.u.cug)
          [!>(`path`pax) !>(cage)]
        [!>((slag (dec p.u.cug) `path`pax)) q.cage]
      ::
      =^  cam  ap-state  (ap-call q.u.cug vase)
      ::
      ?^  cam
        (ap-lame q.u.cug u.cam)
      ap-state
    ::
    ::  +ap-pout: specific take.
    ::
    ++  ap-pout
      |=  [=path =cuft]
      ^+  ap-state
      ::
      ?-  -.cuft
        %coup  (ap-take q.q.pry %coup +.path (some !>(p.cuft)))
        %diff  (ap-diff q.q.pry path p.cuft)
        %quit  (ap-take q.q.pry %quit +.path ~)
        %reap  (ap-take q.q.pry %reap +.path (some !>(p.cuft)))
      ==
    ::
    ::  +ap-prep: install.
    ::
    ++  ap-prep
      |=  vux=(unit vase)
      ^-  [(unit tang) _ap-state]
      ::
      =^  gac  ap-state  (ap-prop vux)
      ::
      :-  gac
      %=    ap-state
          misvale.sat
        ~?  !=(misvale.sat *misvale-data)  misvale-drop+misvale.sat
        *misvale-data                 ::  new app might mean new marks
      ::
          arms.sat
        ~
      ::
          dub
        :_(dub ?~(gac [%& dap ?~(vux %boot %bump) now] [%| u.gac]))
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
        =+  [new=p:(slot 13 hav.sat) old=p:(slot 13 u.vux)]
        ::
        ?.  (~(nest ut p:(slot 13 hav.sat)) %| p:(slot 13 u.vux))
          :_(ap-state `(ap-suck "prep mismatch"))
        (some ap-state(+13.q.hav.sat +13.q.u.vux))
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
      =/  wim  (~(get by sup.ged.sat) ost)
      ?~  wim
        ap-state
      ::
      %_  ap-state
        sup.ged.sat  (~(del by sup.ged.sat) ost)
        qel.ged.sat  (~(del by qel.ged.sat) ost)
      ==
    ::
    ::  +ap-pull: load delete.
    ::
    ++  ap-pull
      ^+  ap-state
      ::
      =/  wim  (~(get by sup.ged.sat) ost)
      ?~  wim
        ap-state
      ::
      =:  sup.ged.sat  (~(del by sup.ged.sat) ost)
          qel.ged.sat  (~(del by qel.ged.sat) ost)
      ==
      ::
      =^  cug  ..ap-pull  (ap-find %pull q.u.wim)
      ::
      ?~  cug
        ap-state
      ::
      =^  cam  ap-state
        %+  ap-call  q.u.cug
        !>((slag p.u.cug q.u.wim))
      ::
      ?^  cam
        (ap-lame q.u.cug u.cam)
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
      |=  [=ship =term =path vux=(unit vase)] :: FIXME delete first arg
      ^+  ap-state
      ::
      =^  cug  ap-state  (ap-find term path)
      ::
      ?~  cug
        ap-state
      ::
      =^  cam  ap-state
        %+  ap-call  q.u.cug
        =+  den=!>((slag p.u.cug path))
        ?~(vux den (slop den u.vux))
      ::
      ?^  cam
        (ap-lame q.u.cug u.cam)
      ap-state
    ::
    ::  +ap-safe: process move list.
    ::
    ++  ap-safe
      ~/  %ap-safe
      |=  =vase
      ^-  [(each (list cove) tang) _ap-state]
      ::
      ?~  q.vase
        =/  that  [%.y ~]
        [that ap-state]
      ::
      ?@  q.vase
        =/  that  [%.n (ap-suck "move: malformed list")]
        [that ap-state]
      ::
      =^  hed  vel.sat  (~(slot wa vel.sat) 2 vase)
      =^  sud  ap-state  (ap-move hed)
      ::
      ?:  ?=(%| -.sud)
        [sud ap-state]
      ::
      =^  tel  vel.sat  (~(slot wa vel.sat) 3 vase)
      =^  res  ap-state  $(vase tel)
      ::
      =/  that
        ?:  ?=(%.n -.res)
          res
        [%.y p.sud p.res]
      ::
      [that ap-state]
    ::
    ::  +ap-sake: handle result.
    ::
    ++  ap-sake
      ~/  %ap-sake
      |=  =vase
      ^-  [(unit tang) _ap-state]
      ::
      ?:  ?=(@ q.vase)
        =/  suck  (ap-suck "sake: invalid product (atom)")
        [(some suck) ap-state]
      ::
      =^  hed  vel.sat  (~(slot wa vel.sat) 2 vase)
      =^  muz  ap-state  (ap-safe hed)
      ::
      ?:  ?=(%.n -.muz)
        [(some p.muz) ap-state]
      ::
      =^  tel  vel.sat  (~(slot wa vel.sat) 3 vase)
      =^  sav  ap-state  (ap-save tel)
      ::
      ?:  ?=(%.n -.sav)
        [(some p.sav) ap-state]
      ::
      :-  ~
      %_  ap-state
        zip  (weld (flop p.muz) zip)
        hav.sat  p.sav
      ==
    ::
    ::  +ap-save: verify core.
    ::
    ++  ap-save
      ~/  %ap-save
      |=  vax=vase
      ^-  [(each vase tang) _ap-state]
      ::
      =^  gud  vel.sat  (~(nest wa vel.sat) p.hav.sat p.vax)
      ::
      :_  ap-state
      ?.  gud
        [%.n (ap-suck "invalid core")]
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
        (~(mint wa vel.sat) [%cell p.gat p.arg] [%cnsg [%$ ~] [%$ 2] [%$ 3] ~])
      ::
      ?:  ?=(%.n -.wyz)
        %-  =/  sam  (~(peek ut p.gat) %free 6)
            (slog >%ap-slam-mismatch< ~(duck ut p.arg) ~(duck ut sam) ~)
        =/  that  [%.n (ap-suck "call: {<cog>}: type mismatch")]
        [that ap-state]
      ::
      :_  ap-state(vel.sat +>.wyz)
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
        %bonk  `%a
        %build  `%f
        %cash  `%a
        %conf  `%g
        %cred  `%c
        %crew  `%c
        %crow  `%c
        %deal  `%g
        %dirk  `%c
        %drop  `%c
        %flog  `%d
        %info  `%c
        %keep  `%f
        %kill  `%f
        %look  `%j
        %merg  `%c
        %mint  `%j
        %mont  `%c
        %nuke  `%a
        %ogre  `%c
        %perm  `%c
        %rest  `%b
        %rule  `%e
        %serv  `%e
        %snap  `%j
        %them  `%e
        %wait  `%b
        %want  `%a
        %warp  `%c
        %well  `%e
        %well  `%e
        %wind  `%j
        %wipe  `%f
      ==
    --
  --
::
++  call                                                ::  request
  ~%  %gall-call  +>   ~
  |=  [hen=duct hic=(hypo (hobo task:able))]
  ^+  [*(list move) ..^$]
  ::
  =>  .(q.hic ?.(?=($soft -.q.hic) q.hic ((hard task:able) p.q.hic)))
  ::
  ?-    -.q.hic
      ::
      %conf
      ::
    =/  doc=dock  p.q.hic
    =/  syp=ship  p.doc
    ?.  =(our syp)
      ~&  [%gall-not-ours syp]
      [~ ..^$]
    ::
    =/  booted
      =/  initialised  (mo-abed:mo hen)
      =/  dud=dude  q.doc
      =/  des=(pair ship desk)  q.q.hic
      (mo-boot:initialised dud des)
    ::
    mo-abet:booted
  ::
      ::
      %deal
      ::
    =<  mo-abet
    ?.  =(our q.p.q.hic)                                ::  either to us
      ?>  =(our p.p.q.hic)                              ::  or from us
      (mo-away:(mo-abed:mo hen) q.p.q.hic q.q.hic)
    (mo-come:(mo-abed:mo hen) p.p.q.hic q.q.hic)
  ::
      ::
      %init
      ::
    [~ ..^$(sys.mast.all hen)]
  ::
      ::
      %sunk  [~ ..^$]
      ::
  ::
      ::
      %vega  [~ ..^$]
      ::
  ::
      ::
      %west
      ::
    ?>  ?=({?($ge $gh) @ ~} q.q.hic)
    =*  dap  i.t.q.q.hic
    =*  him  p.q.hic
    ?:  ?=($ge i.q.q.hic)
      =+  mes=((hard {@ud rook}) r.q.hic)
      =<  mo-abet
      (mo-gawk:(mo-abed:mo hen) him dap mes)
    =+  mes=((hard {@ud roon}) r.q.hic)
    =<  mo-abet
    (mo-gawd:(mo-abed:mo hen) him dap mes)
  ::
      ::
      %wegh
      ::
    =/  =mass
      :+  %gall  %|
      :~  foreign+&+sap.mast.all
          :+  %blocked  %|
          (sort ~(tap by (~(run by wub.mast.all) |=(sofa [%& +<]))) aor)
          :+  %active   %|
          (sort ~(tap by (~(run by bum.mast.all) |=(seat [%& +<]))) aor)
          dot+&+all
      ==
    =/  =move  [hen %give %mass mass]
    [[move ~] ..^$]
  ==
::
++  load                                                ::  recreate vane
  |=  old/axle-n
  ^+  ..^$
  ?-  -.old
      $0  ..^$(all old)
  ==
::
++  scry
  ~/  %gall-scry
  |=  {fur/(unit (set monk)) ren/@tas why/shop syd/desk lot/coin tyl/path}
  ^-  (unit (unit cage))
  ?.  ?=(%& -.why)  ~
  =*  his  p.why
  ?:  ?&  =(%u ren)
          =(~ tyl)
          =([%$ %da now] lot)
          =(our his)
      ==
    ``[%noun !>((~(has by bum.mast.all) syd))]
  ?.  =(our his)
    ~
  ?.  =([%$ %da now] lot)
    ~
  ?.  (~(has by bum.mast.all) syd)
    [~ ~]
  ?.  ?=(^ tyl)
    ~
  (mo-peek:mo-abed:mo syd high+`his ren tyl)
::
++  stay                                                ::  save w+o cache
  `axle`all
::
++  take                                                ::  response
  ~/  %gall-take
  |=  {tea/wire hen/duct hin/(hypo sign-arvo)}
  ^+  [*(list move) ..^$]
  ~|  [%gall-take tea]
  ?>  ?=([?($sys $use) *] tea)
  =+  mow=(mo-abed:mo hen)
  ?-  i.tea
    $sys  mo-abet:(mo-cyst:mow t.tea q.hin)
    $use  mo-abet:(mo-cook:mow t.tea hin)
  ==
--
