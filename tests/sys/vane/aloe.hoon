/+  *test
::
/=  aloe-raw  /:  /===/sys/vane/aloe
              /!noun/
::
=/  test-pit=vase  !>(..zuse)
=/  aloe-gate  (aloe-raw test-pit)
::  some common test fixtures
::
=/  fix
  =/  our  ~nul
  =/  our-life=life  2
  =/  our-crub  (pit:nu:crub:crypto 512 (shaz 'Alice'))
  =/  our-private-key=ring  sec:ex:our-crub
  =/  our-public-key=pass  pub:ex:our-crub
  ::
  =/  her  ~doznec-doznec
  =/  her-life=life  3
  =/  her-crub  (pit:nu:crub:crypto 512 (shaz 'Bob'))
  =/  her-private-key=ring  sec:ex:her-crub
  =/  her-public-key=pass  pub:ex:her-crub
  ::
  :*  now=~2222.2.2
      eny=0xdead.beef
      ::
      our=our
      our-life=our-life
      our-crub=our-crub
      our-private-key=our-private-key
      our-public-key=our-public-key
      our-sponsors=~
      ::
      her=her
      her-life=her-life
      her-crub=her-crub
      her-private-key=her-private-key
      her-public-key=her-public-key
      her-sponsors=~[~marzod ~zod]
      ::
      her-public-keys=(my [her-life her-public-key]~)
  ==
::
=/  aloe  (aloe-gate our.fix now.fix `@`eny.fix scry=*sley)
::
|%
++  test-packet-encoding  ^-  tang
  ::
  =/  =raw-packet:aloe
    [[to=~nec from=~doznec-doznec] encoding=%none payload=(jam [42 43])]
  ::
  =/  encoded  (encode-raw-packet:aloe raw-packet)
  =/  decoded  (decode-raw-packet:aloe encoded)
  ::
  %+  expect-eq
    !>  raw-packet
    !>  decoded
::
++  test-interpret-packet-none  ^-  tang
  ::
  =/  test-meal=meal:aloe  [%bond [1 1] /remote-route [%foo %bar]]
  ::
  =/  formatted=none:packet-format:aloe  raw-payload=(jam test-meal)
  ::
  =/  interpreted
    %.  [%none formatted]
    %-  interpret-packet:aloe  :*
      her.fix
      our-crub.fix
      ^-  pki-info:aloe
      [fast-key=~ her-life.fix her-public-keys.fix her-sponsors.fix]
    ==
  ::
  %+  expect-eq
    !>  [gifts=~ authenticated=%.n meal=test-meal]
    !>  interpreted
::
++  test-interpret-packet-open-no-deed  ^-  tang
  ::
  =/  test-meal=meal:aloe  [%bond [1 1] /remote-route [%foo %bar]]
  =/  jammed-meal=@        (jam test-meal)
  =/  signed-payload=@     (sign:as:her-crub.fix jammed-meal)
  ::
  =/  formatted=open:packet-format:aloe
    [from=her-life.fix deed=~ signed-payload]
  ::
  =/  packet-interpreter
    %-  interpret-packet:aloe  :*
      her.fix
      our-crub.fix
      ^-  pki-info:aloe
      [fast-key=~ her-life.fix her-public-keys.fix her-sponsors.fix]
    ==
  ::
  =/  interpreted
    %-  packet-interpreter
    [%open (jam formatted)]
  ::
  %+  expect-eq
    !>  [gifts=~ authenticated=%.y meal=test-meal]
    !>  interpreted
::
++  test-interpret-packet-fast  ^-  tang
  ::
  =/  test-meal=meal:aloe            [%bond [1 1] /remote-route [%foo %bar]]
  =/  jammed-meal=@                  (jam test-meal)
  =/  =symmetric-key:aloe            `@uvI`0xbeef.cafe
  =/  hashed-key=key-hash:aloe       (shaf %hand symmetric-key)
  ::
  =/  encrypted=@  (en:crub:crypto `@J`symmetric-key jammed-meal)
  =/  formatted=@  (cat 7 hashed-key encrypted)
  ::
  =/  packet-interpreter
    %-  interpret-packet:aloe  :*
      her.fix
      our-crub.fix
      ^-  pki-info:aloe
      :*  :-  ~
          :+  key-hash=`@uvH`hashed-key
            expiration-date=`@da`(add ~d1 now.fix)
          value=symmetric-key
      ::
          her-life.fix
          her-public-keys.fix
          her-sponsors.fix
      ==
    ==
  ::
  =/  interpreted
    %-  packet-interpreter
    [%fast formatted]
  ::
  %+  expect-eq
    !>  [gifts=~ authenticated=& meal=test-meal]
    !>  interpreted
::
++  test-interpret-packet-full  ^-  tang
  ::
  =/  test-meal=meal:aloe  [%bond [1 1] /remote-route [%foo %bar]]
  =/  jammed-meal=@        (jam test-meal)
  =/  =symmetric-key:aloe  (shaz %symmetric-key-foo)
  =/  jammed-message=@     (jam symmetric-key jammed-meal)
  =/  encrypted=@  (seal:as:her-crub.fix our-public-key.fix jammed-message)
  ::
  =/  formatted=full:packet-format:aloe
    [[to=our-life.fix from=her-life.fix] deed=~ encrypted]
  ::
  =/  packet-interpreter
    %-  interpret-packet:aloe  :*
      her.fix
      our-crub.fix
      ^-  pki-info:aloe
      [fast-key=~ her-life.fix her-public-keys.fix her-sponsors.fix]
    ==
  ::
  =/  interpreted
    %-  packet-interpreter
    [%full (jam formatted)]
  ::
  %+  expect-eq
    !>  :+  ^=  gifts
            :~  [%symmetric-key symmetric-key]
                [%meet her her-life her-public-key]:fix
            ==
          authenticated=%.y
        meal=test-meal
    ::
    !>  interpreted
::
::  +encode-meal tests
::
++  test-encode-meal-carp  ^-  tang
  ::
  =/  encoder
    %-  encode-meal:aloe  :*
      our.fix
      our-life.fix
      our-crub.fix
      her.fix
      ^-  pki-info:aloe
      [fast-key=~ her-life.fix her-public-keys.fix her-sponsors.fix]
    ==
  ::
  =/  packet      %packet-foo
  =/  =meal:aloe  [%carp *message-descriptor:aloe 42 `@`packet]
  =/  result1
    %-  encoder
    [now.fix eny.fix meal]
  ::
  =/  spat
    ^-  partial-message-blob:aloe
    ^-  @
    (encode-raw-packet:aloe [our.fix her.fix] %none (jam meal))
  ::
  %+  expect-eq
    !>  [~ ~[spat]]
    !>  result1
::
++  test-encode-meal-bond-full  ^-  tang
  ::
  =/  encoder
    %-  encode-meal:aloe  :*
      our.fix
      our-life.fix
      our-crub.fix
      her.fix
      ^-  pki-info:aloe
      [fast-key=~ her-life.fix her-public-keys.fix her-sponsors.fix]
    ==
  ::
  =/  message     [%message (gulf 1 2.000)]
  =/  =meal:aloe  [%bond [0 0] /remote/route message]
  =/  result1
    %-  encoder
    [now.fix eny.fix meal]
  ::
  =/  actual-gifts=(list gift:encode-meal:aloe)          gifts.result1
  =/  actual-fragments=(list partial-message-blob:aloe)  parts.result1
  ::
  =/  sit  (sign:as:our-crub.fix (jam meal))
  =/  wrapper-meal=meal:aloe
    [%carp [[0 0] 2 1] 0 sit]
  ::
  =/  maj  (jam wrapper-meal)
  ::
  =/  spat  (encode-raw-packet:aloe [our.fix her.fix] %open maj)
  ::
  ;:  weld
    %+  expect-eq
      !>  6
      !>  (lent actual-fragments)
  ::
    ::  checking against 1.024 fails because header brings it just over that
    ::
    %+  expect-eq
      !>  %.y
      !>  (levy actual-fragments |=(@ (lte (met 3 +<) 1.100)))
  ::  make sure all but the last packet are actually large enough
  ::
    %+  expect-eq
      !>  %.y
      !>  (levy (tail (flop actual-fragments)) |=(@ (gte (met 3 +<) 1.000)))
  ::
    %+  expect-eq
      !>  1
      !>  (lent actual-gifts)
  ::
    %+  expect-eq
      !>  %symmetric-key
      !>  ?>(?=(^ actual-gifts) -.i.actual-gifts)
  ==
::
++  test-encode-meal-full-emit-gift  ^-  tang
  ::
  =/  encoder
    %-  encode-meal:aloe  :*
      our.fix
      our-life.fix
      our-crub.fix
      her.fix
      ^-  pki-info:aloe
      [fast-key=~ her-life.fix her-public-keys.fix her-sponsors.fix]
    ==
  ::
  =/  message     [%message %foo %bar]
  =/  =meal:aloe  [%bond [0 0] /remote/route message]
  ::
  =/  result1
    %-  encoder
    [now=now.fix eny=eny.fix ham=meal]
  ::
  =/  actual-gifts=(list gift:encode-meal:aloe)          gifts.result1
  =/  actual-fragments=(list partial-message-blob:aloe)  parts.result1
  ::
  ;:  weld
    %+  expect-eq
      !>  1
      !>  (lent actual-fragments)
  ::
    %+  expect-eq
      !>  1
      !>  (lent actual-gifts)
  ::
    %+  expect-eq
      !>  %symmetric-key
      !>  ?>(?=(^ actual-gifts) -.i.actual-gifts)
  ==
::
++  test-pump-cull  ^-  tang
  ::
  =/  live-list=(list live-raw-packet:aloe)
    %-  zing
    ::
    %+  turn  (gulf 1 5)
    |=  message-num=@
    ::
    %+  turn  (gulf 42 47)
    |=  fragment-num=@
    ::
    ^-  live-raw-packet:aloe
    ::
    =|  =live-raw-packet:aloe
    %=    live-raw-packet
        fragment-index.raw-packet-descriptor
      [message-num fragment-num]
    ==
  ::
  =/  lost-list=(list raw-packet-descriptor:aloe)
    %-  zing
    ::
    %+  turn  (gulf 3 8)
    |=  message-num=@
    ::
    %+  turn  (gulf 52 57)
    |=  fragment-num=@
    ::
    ^-  raw-packet-descriptor:aloe
    ::
    =|  =raw-packet-descriptor:aloe
    raw-packet-descriptor(fragment-index [message-num fragment-num])
  ::
  =/  =pump-state:aloe
    :+  ^=  live
        %-  ~(gas to *(qeu live-raw-packet:aloe))
        live-list
      ::
      ^=  lost
      %-  ~(gas to *(qeu raw-packet-descriptor:aloe))
      lost-list
    ::
    (initialize-pump-metrics:pump:aloe now.fix)
  ::
  =/  ctx=pump-context:pump:aloe  [~ pump-state]
  ::  cull message 4
  ::
  =/  result1=pump-state:aloe  +:(work:pump:aloe ctx now.fix [%cull 4])
  ::
  ;:  weld
    %+  expect-eq
      !>  %-  ~(gas to *(qeu live-raw-packet:aloe))
          %+  skim  live-list
          |=  =live-raw-packet:aloe
          ^-  ?
          ::
          ?=  ?(%1 %2 %3 %5)
          message-seq.fragment-index.raw-packet-descriptor.live-raw-packet
      ::
      !>  live.result1
  ::
    %+  expect-eq
      !>  %-  ~(gas to *(qeu raw-packet-descriptor:aloe))
          %+  skim  lost-list
          |=  =raw-packet-descriptor:aloe
          ^-  ?
          ::
          ?=  ?(%3 %5 %6 %7 %8)
          message-seq.fragment-index.raw-packet-descriptor
      ::
      !>  lost.result1
  ==
::
++  test-pump-pack  ^-  tang
  ::
  =/  =pump-state:aloe
    :+  live=~
      lost=~
    (initialize-pump-metrics:pump:aloe now.fix)
  ::
  =/  ctx=pump-context:pump:aloe  [~ pump-state]
  ::
  =/  packets=(list raw-packet-descriptor:aloe)
    %+  turn  (gulf 1 2)
    |=  n=@
    ^-  raw-packet-descriptor:aloe
    ::
    =|  =raw-packet-descriptor:aloe
    %_  raw-packet-descriptor
      virgin           %.n
      fragment-index   [message-seq=42 fragment-num=n]
      raw-packet-hash  `@uvH`(shaf n n)
      raw-packet-blob  n
    ==
  ::
  =/  result1=pump-context:pump:aloe
    (work:pump:aloe ctx now.fix [%pack packets])
  ::
  ;:  weld
    %+  expect-eq
      !>  :*  ^=  live-packets      2
              ^=  max-live-packets  2
              ^=  lost-packets      0
          ==
      !>  -.metrics.state.result1
  ::
    %+  expect-eq
      !>  :~  :-  %send
              [raw-packet-hash fragment-index raw-packet-blob]:(snag 0 packets)
            ::
              :-  %send
              [raw-packet-hash fragment-index raw-packet-blob]:(snag 1 packets)
          ==
      !>  gifts.result1
  ==
::
++  test-message-manager-mess-basic  ^-  tang
  ::
  =/  =pki-context:aloe
    =-  [our.fix our-life.fix our-crub.fix her.fix -]
    ^-  pki-info:aloe
    [fast-key=~ her-life.fix her-public-keys.fix her-sponsors.fix]
  ::
  =/  =pump-state:aloe
    :+  live=~
      lost=~
    (initialize-pump-metrics:pump:aloe now.fix)
  ::
  =/  =outbound-state:aloe
    :*  ^=  next-tick      0
        ^=  till-tick      0
        ^=  live-messages  ~
        pump-state
    ==
  ::
  =/  manager0
    %-  message-manager:aloe
    [pki-context now.fix eny.fix bone=4 outbound-state]
  ::
  =/  manager1
    %-  work:manager0
    ^-  task:manager0
    [%mess /remote/route/foo message=[%message %foo]]
  ::
  =/  result1  abet:manager1
  ::
  =/  manager2
    %-  work:manager1
    ^-  task:manager1
    [%back raw-packet-hash=0v7.o5rlu.ms7sv.kmf23.o2r5g.je1fl error=~ lag=`@dr`0]
  ::
  =/  result2
    abet:manager2
  ::
  ;:  weld
    %+  expect-eq
      !>  2
      !>  (lent gifts.result2)
  ::
    ::  assert key expiration date is in the future
    ::
    %+  expect-eq
      !>  %.y
      !>  %+  lth  now.fix
          =-  ?>  ?=(%symmetric-key -.-)
              expiration-date.-
          ^-  gift:manager2
          %+  snag  0
          %+  skim  gifts.result2
          |=  ^
          ^-  ?
          ?=(%symmetric-key -.+<)
  ::
    %+  expect-eq
      !>  [next-tick=1 till-tick=0]
      !>  [next-tick till-tick]:outbound-state.result2
  ::
    %+  expect-eq
      !>  [live-packets=0 lost-packets=0 last-sent=now.fix]
      !>  =<  [live-packets lost-packets last-sent]
          metrics.pump-state.outbound-state.result2
  ==
::
++  test-message-manager-mess-fragments  ^-  tang
  ::
  =/  =pki-context:aloe
    =-  [our.fix our-life.fix our-crub.fix her.fix -]
    ^-  pki-info:aloe
    [fast-key=~ her-life.fix her-public-keys.fix her-sponsors.fix]
  ::
  =/  =pump-state:aloe
    :+  live=~
      lost=~
    (initialize-pump-metrics:pump:aloe now.fix)
  ::
  =/  =outbound-state:aloe
    :*  ^=  next-tick      0
        ^=  till-tick      0
        ^=  live-messages  ~
        pump-state
    ==
  ::
  =/  manager0
    %-  message-manager:aloe
    [pki-context now.fix eny.fix bone=4 outbound-state]
  ~&  %manager0
  ::
  =/  manager1
    %-  work:manager0
    ^-  task:manager0
    [%mess /remote/route/foo message=[%message (gulf 1 2.000)]]
  ~&  %manager1
  ::
  =/  result1  abet:manager1
  ~&  :-  %manager1-abet
      (window-slots:pump:aloe metrics.pump-state.outbound-state.result1)
  ::  at a new date, ack first packet
  ::
  =/  new-date  `@da`(add now.fix ~s10)
  =/  manager2
    %-  message-manager:aloe
    [pki-context new-date eny.fix bone=4 outbound-state.result1]
  ~&  :-  %manager2
      (window-slots:pump:aloe metrics.pump-state.outbound-state.manager2)
  ::
  =/  manager3
    %-  work:manager2
    ^-  task:manager2
    [%back raw-packet-hash=0v6.hdfn2.kv3md.d4dv2.npoj8.nkd8k error=~ lag=`@dr`0]
  ~&  :-  %manager3
      (window-slots:pump:aloe metrics.pump-state.outbound-state.manager3)
  ::
  =/  result3  abet:manager3
  ~&  :-  %manager3-abet
      (window-slots:pump:aloe metrics.pump-state.outbound-state.result3)
  ::
  ;:  weld
    %+  expect-eq
      !>  1
      !>  (lent (skim gifts.result1 is-gift-symmetric-key))
  ::
    %+  expect-eq
      !>  2
      !>  (lent (skim gifts.result1 is-gift-send))
  ::
    %+  expect-eq
      !>  0
      !>  (window-slots:pump:aloe metrics.pump-state.outbound-state.result1)
  ::
    %+  expect-eq
      !>  [live-packets=2 lost-packets=0]
      !>  [live-packets lost-packets]:metrics.pump-state.outbound-state.result1
  ::
    %+  expect-eq
      !>  1
      !>  (lent (skim gifts.result3 is-gift-send))
  ::
    %+  expect-eq
      !>  [live-packets=2 lost-packets=0]
      !>  [live-packets lost-packets]:metrics.pump-state.outbound-state.result3
  ==
::
++  test-message-manager-mess-ack-out-of-order  ^-  tang
  ::
  =/  =pki-context:aloe
    =-  [our.fix our-life.fix our-crub.fix her.fix -]
    ^-  pki-info:aloe
    [fast-key=~ her-life.fix her-public-keys.fix her-sponsors.fix]
  ::
  =/  =pump-state:aloe
    :+  live=~
      lost=~
    (initialize-pump-metrics:pump:aloe now.fix)
  ::
  =/  =outbound-state:aloe
    :*  ^=  next-tick      0
        ^=  till-tick      0
        ^=  live-messages  ~
        pump-state
    ==
  ::
  =/  manager0
    %-  message-manager:aloe
    [pki-context now.fix eny.fix bone=4 outbound-state]
  ~&  %manager0
  ::
  =/  manager1
    %-  work:manager0
    ^-  task:manager0
    [%mess /remote/route/foo message=[%message (gulf 1 2.000)]]
  ~&  %manager1
  ::
  =/  result1  abet:manager1
  ~&  :-  %manager1-abet
      (window-slots:pump:aloe metrics.pump-state.outbound-state.result1)
  ::  at a new date, ack second packet, but not the first
  ::
  =/  new-date  `@da`(add now.fix ~s10)
  =/  manager2
    %-  message-manager:aloe
    [pki-context new-date eny.fix bone=4 outbound-state.result1]
  ~&  :-  %manager2
      (window-slots:pump:aloe metrics.pump-state.outbound-state.manager2)
  ::
  =/  manager3
    %-  work:manager2
    ^-  task:manager2
    [%back raw-packet-hash=0v6.e5p8r.rb8jv.qs7r4.d2d8i.ajbuk error=~ lag=`@dr`0]
  ~&  :-  %manager3
      (window-slots:pump:aloe metrics.pump-state.outbound-state.manager3)
  ::
  =/  result3  abet:manager3
  ~&  :-  %manager3-abet
      (window-slots:pump:aloe metrics.pump-state.outbound-state.result3)
  ::
  ;:  weld
    %+  expect-eq
      !>  1
      !>  (lent (skim gifts.result1 is-gift-symmetric-key))
  ::
    %+  expect-eq
      !>  2
      !>  (lent (skim gifts.result1 is-gift-send))
  ::
    %+  expect-eq
      !>  0
      !>  (window-slots:pump:aloe metrics.pump-state.outbound-state.result1)
  ::
    %+  expect-eq
      !>  [live-packets=2 lost-packets=0]
      !>  [live-packets lost-packets]:metrics.pump-state.outbound-state.result1
  ::
    %+  expect-eq
      !>  2
      !>  (lent (skim gifts.result3 is-gift-send))
  ::
    %+  expect-eq
      !>  [live-packets=2 lost-packets=0]
      !>  [live-packets lost-packets]:metrics.pump-state.outbound-state.result3
  ==
::
++  is-gift-send
  |*  gift=^
  ^-  ?
  ?=(%send -.gift)
::
++  is-gift-symmetric-key
  |*  gift=^
  ^-  ?
  ?=(%symmetric-key -.gift)
::
++  aloe-call
  |=  $:  aloe-gate=_aloe-gate
          now=@da
          call-args=[=duct wrapped-task=(hypo (hobo task:able:aloe-gate))]
          expected-moves=(list move:aloe-gate)
      ==
  ^-  [tang _aloe-gate]
  ::
  =/  aloe  (aloe-gate our=~nul now=now eny=`@`0xdead.beef scry=*sley)
  ::
  =^  moves  aloe-gate
    %-  call:aloe  call-args
  ::
  =/  output=tang
    %+  expect-eq
      !>  expected-moves
      !>  moves
  ::
  [output aloe-gate]
--
