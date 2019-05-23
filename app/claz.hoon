::  claz: command line azimuth, for the power-user
::
/-  sole-sur=sole
/+  sole-lib=sole
::
=,  azimuth
=,  ethereum
=,  rpc
=,  key
=,  rpc:jstd
::
|%
++  state
  $:  cli=shell
      inp=in-progress
  ==
::
++  in-progress
  %-  unit
  $%  [%nonce nonce=eval-form:eval:nonce-glad]
  ==
::
++  null-glad   (glad ,~)
++  nonce-glad  (glad ,@ud)
::
+$  glad-input  response:rpc:jstd  ::TODO  maybe just json? idk refactor unwrap
::
++  glad-output-raw
  |*  a=mold
  $~  [~ %done *a]
  $:  moves=(list move)
      $=  next
      $%  [%wait ~]
          [%cont self=(glad-form-raw a)]
          [%fail err=tang]
          [%done value=a]
      ==
  ==
::
++  glad-form-raw
  |*  a=mold
  $-(glad-input (glad-output-raw a))
::
++  glad-fail
  |=  err=tang
  |=  glad-input
  [~ ~ %fail err]
::
++  glad
  |*  a=mold
  |%
  ++  output  (glad-output-raw a)  ::
  ++  form    (glad-form-raw a)  ::  $-(input (output @ud))
  ++  pure
    |=  arg=a
    ^-  form
    |=  glad-input
    [~ %done arg]
  ::
  ++  bind
    |*  b=mold
    |=  [m-b=(glad-form-raw b) fun=$-(b form)]
    ^-  form
    |=  input=glad-input
    =/  b-res=(glad-output-raw b)
      (m-b input)
    ^-  output
    :-  moves.b-res
    ?-  -.next.b-res
      %wait  [%wait ~]
      %cont  [%cont ..$(m-b self.next.b-res)]
      %fail  [%fail err.next.b-res]
      %done  [%cont (fun value.next.b-res)]
    ==
  ::
  ++  eval
    |%
    +$  eval-form
      $:  effects=(list move)
          =form
      ==
    ::
    +$  eval-result
      $%  [%next ~]
          [%fail err=tang]
          [%done value=a]
      ==
    ::
    ++  take
      =|  moves=(list move)
      |=  [=eval-form =our=wire =glad-input]
      ^-  [[(list move) =eval-result] _eval-form]
      ::  run the glad callback
      ::
      =/  =output  (form.eval-form glad-input)
      ::  add moves
      ::
      =.  moves
        (weld moves moves.output)
      ::  case-wise handle next steps
      ::
      ?-  -.next.output
        %wait  [[moves %next ~] eval-form]
        %fail  [[moves %fail err.next.output] eval-form]
        %done  [[moves %done value.next.output] eval-form]
      ::
          %cont
        ::  recurse to run continuation with initialization move
        ::
        %_  $
          form.eval-form   self.next.output
          glad-input       *response:rpc:jstd  ::TODO  empty unit of response:rpc:jstd?
        ==
      ==
    --
  --
::
++  shell
  $:  id=bone
      say=sole-share:sole-sur
  ==
::
++  command
  $%  [%generate =path =network as=address =batch]
  ==
::
++  network
  $?  %main
      %ropsten
      %fake
      [%other id=@]
  ==
::
++  batch
  $%  [%single =call]
      [%deed deeds-json=cord]
      [%lock what=(list ship) to=address =lockup]
  ==
::
++  lockup
  $%  [%linear windup-years=@ud unlock-years=@ud]
      [%conditional [b1=@ud b2=@ud b3=@ud] unlock-years-per-batch=@ud]
  ==
::
++  rights
  $:  own=address
      manage=(unit address)
      voting=(unit address)
      transfer=(unit address)
      spawn=(unit address)
      net=(unit [crypt=@ux auth=@ux])
  ==
::
++  call
  $%  [%create-galaxy gal=ship to=address]
      [%spawn who=ship to=address]
      [%configure-keys who=ship crypt=@ auth=@]
      [%set-management-proxy who=ship proxy=address]
      [%set-voting-proxy who=ship proxy=address]
      [%set-spawn-proxy who=ship proxy=address]
      [%transfer-ship who=ship to=address]
      [%set-transfer-proxy who=ship proxy=address]
  ==
::
++  move  (pair bone card)
++  card
  $%  [%hiss wire ~ mark %hiss hiss:eyre]
      [%info wire desk nori:clay]
      [%rest wire @da]
      [%wait wire @da]
  ==
::
::
++  ecliptic  `address`0x6ac0.7b7c.4601.b5ce.11de.8dfe.6335.b871.c7c4.dd4d
--
::
|_  [=bowl:gall state]
++  this  .
::
++  prep
  |=  old=(unit *)
  ^-  (quip move _this)
  [~ ..prep]
::
++  sigh-tang-nonce
  |=  [=wire =tang]
  ^-  (quip move _this)
  [~ (fail-nonce tang)]
::
++  sigh-json-rpc-response-nonce
  |=  [=wire =response:rpc:jstd]
  ^-  (quip move _this)
  ?~  inp
    ~|(%no-in-progress !!)
  :: ?.  ?=(%nonce -.u.inp)  ::NOTE  mint-vain rn
  ::   ~|([%unexpected-response -.u.inp] !!)
  ~&  %sigh-nonce
  ::  nonce result
  ::
  =/  m  nonce-glad
  =^  r=[moves=(list move) =eval-result:eval:m]  nonce.u.inp
    (take:eval:m nonce.u.inp wire response)
  ~&  [%sigh-did-eval r]
  :-  moves.r
  ?-  -.eval-result.r
    %next  this
    %fail  (fail-nonce err.eval-result.r)
    %done  (done-nonce value.eval-result.r)
  ==
::
++  fail-nonce
  |=  err=tang
  ^+  this
  ~&  'nonce fetching failed'
  ::TODO  error printing
  this(inp ~)
::
++  done-nonce  ::TODO  ??? why
  |=  nonce=@ud
  ^+  this
  ~&  [%done-nonce nonce]
  ::TODO  continue work
  this(inp ~)
::
++  poke-noun
  |=  =command
  ^-  (quip move _this)
  =.  inp
    %-  some
    :-  %nonce
    ^-  eval-form:eval:nonce-glad
    (get-next-nonce as.command)
  ~&  %got-command--kicking-sigh
  =^  moves  this
    (sigh-json-rpc-response-nonce / *response:rpc:jstd)
  [moves this]
  :: :+  ~  %cont
  :: |=  glad-input
  :: ?-  -.command
  ::     %generate
  ::   =-  [[- ~] this]
  ::   %+  write-file-transactions
  ::     path.command
  ::   ::TODO  probably just store network and nonce in tmp state?
  ::   ?-  -.batch.command
  ::     %single  [(single nonce [network as +.batch]:command) ~]
  ::     %deed    (deed nonce [network as +.batch]:command)
  ::     %lock    (lock nonce [network as +.batch]:command)
  ::   ==
  :: ==
::
++  get-next-nonce
  |=  for=address
  ^-  eval-form:eval:nonce-glad
  :-  ~  ::  ??? unexpected but ok
  ;<  ~  bind:nonce-glad
    ::  initialization
    ::
    ^-  form:null-glad
    |=  glad-input
    ~&  [%get-next-nonce-init for]
    ^-  output:null-glad
    =-  [[[ost.bowl -] ~] %done ~]
    ^-  [%hiss wire ~ mark %hiss hiss:eyre]
    :+  %hiss  /nonce
    :+  ~  %json-rpc-response
    :-  %hiss
    %+  json-request:rpc:ethereum  ::NOTE  find error???
      (need (de-purl:html 'http://eth-mainnet.urbit.org:8545'))
    %+  request-to-json
      `'some-id'
    ::TODO  add eth_getTransactionCount to stdlib
    [%eth-block-number ~]
  ^-  form:nonce-glad
  |=  res=glad-input
  :: ^-  output:m  ::  incorrect?
  ?:  =(res *glad-input)
    ::  got initialized?
    ~&  [%get-next-nonce-init-wait]
    [~ %wait ~]
  ~&  [%get-next-nonce-got-res res]
  =/  nonce=@ud  314
  [~ %done nonce]
::
++  tape-to-ux
  |=  t=tape
  (scan t zero-ux)
::
++  zero-ux
  ;~(pfix (jest '0x') hex)
::
++  write-file-transactions
  |=  [pax=path tox=(list transaction)]
  ^-  move
  ?>  ?=([@ desk @ *] pax)
  :*  ost.bowl
      %info
      (weld /write pax)
      :: our.bowl
      `desk`i.t.pax
      =-  &+[t.t.t.pax -]~
      =/  y  .^(arch %cy pax)
      ?~  fil.y
        ins+eth-txs+!>(tox)
      mut+eth-txs+!>(tox)
  ==
::
++  do
  ::TODO  maybe reconsider encode-call interface, if we end up wanting @ux
  ::      as or more often than we want tapes
  |=  [=network nonce=@ud to=address dat=$@(@ux tape)]
  ^-  transaction
  :*  nonce
      8.000.000.000.000  ::TODO  global config
      600.000  ::TODO  global config
      to
      0
      `@`?@(dat dat (tape-to-ux dat))
      ?-  network
        %main       0x1
        %ropsten    0x3
        %fake       `@ux``@`1.337
        [%other *]  id.network
      ==
  ==
::
++  single
  |=  [nonce=@ud =network as=address =call]
  ^-  transaction
  =-  (do network nonce ecliptic -)
  ?-  -.call
    %create-galaxy  (create-galaxy:dat +.call)
    %spawn  (spawn:dat +.call)
    %configure-keys  (configure-keys:dat +.call)
    %set-management-proxy  (set-management-proxy:dat +.call)
    %set-voting-proxy  (set-voting-proxy:dat +.call)
    %set-spawn-proxy  (set-spawn-proxy:dat +.call)
    %transfer-ship  (transfer-ship:dat +.call)
    %set-transfer-proxy  (set-transfer-proxy:dat +.call)
  ==
::
++  deed
  |=  [nonce=@ud =network as=address deeds-json=cord]
  ^-  (list transaction)
  =/  deeds=(list [=ship rights])
    (parse-registration deeds-json)
  ::TODO  split per spawn proxy
  =|  txs=(list transaction)
  |^  ::  $
    ?~  deeds  (flop txs)
    =*  deed  i.deeds
    =.  txs
      ?.  ?=(%czar (clan:title ship.deed))
        %-  do-here
        (spawn:dat ship.deed as)
      ~|  %galaxy-held-by-ceremony
      ?>  =(0x740d.6d74.1711.163d.3fca.cecf.1f11.b867.9a7c.7964 as)
      ~&  [%assuming-galaxy-owned-by-ceremony ship.deed]
      txs
    =?  txs  ?=(^ net.deed)
      %-  do-here
      (configure-keys:dat [ship u.net]:deed)
    =?  txs  ?=(^ manage.deed)
      %-  do-here
      (set-management-proxy:dat [ship u.manage]:deed)
    =?  txs  ?=(^ voting.deed)
      %-  do-here
      (set-voting-proxy:dat [ship u.voting]:deed)
    =?  txs  ?=(^ spawn.deed)
      %-  do-here
      (set-spawn-proxy:dat [ship u.spawn]:deed)
    =.  txs
      %-  do-here
      (transfer-ship:dat [ship own]:deed)
    $(deeds t.deeds)
  ::
  ::TODO  maybe-do, take dat gat and unit argument
  ++  do-here
    |=  dat=tape
    :_  txs
    (do network (add nonce (lent txs)) ecliptic dat)
  --
::
++  parse-registration
  |=  reg=cord
  ^-  (list [=ship rights])
  ~|  %registration-json-insane
  =+  jon=(need (de-json:html reg))
  ~|  %registration-json-invalid
  ?>  ?=(%o -.jon)
  =.  p.jon  (~(del by p.jon) 'idCode')
  %+  turn  ~(tap by p.jon)
  |=  [who=@t deed=json]
  ^-  [ship rights]
  :-  (rash who dum:ag)
  ?>  ?=(%a -.deed)
  ::  array has contents of:
  ::  [owner, transfer, spawn, mgmt, delegate, auth_key, crypt_key]
  ~|  [%registration-incomplete deed (lent p.deed)]
  ?>  =(7 (lent p.deed))
  =<  :*  (. 0 %address)       ::  owner
          (. 3 %unit-address)  ::  management
          (. 4 %unit-address)  ::  voting
          (. 1 %unit-address)  ::  transfer
          (. 2 %unit-address)  ::  spawn
          (both (. 6 %key) (. 5 %key))  ::  crypt, auth
      ==
  |*  [i=@ud what=?(%address %unit-address %key)]
  =+  j=(snag i p.deed)
  ~|  [%registration-invalid-value what j]
  ?>  ?=(%s -.j)
  %+  rash  p.j
  =+  adr=;~(pfix (jest '0x') hex)
  ?-  what
    %address       adr
    %unit-address  ;~(pose (stag ~ adr) (cold ~ (jest '')))
    %key           ;~(pose (stag ~ hex) (cold ~ (jest '')))
  ==
::
::TODO  need secondary kind of lockup logic, where
::      1) we need to batch-transfer stars to the ceremony
::      2) (not forget to register and) deposit already-active stars
++  lock
  |=  [nonce=@ud =network as=address what=(list ship) to=address =lockup]
  ^-  (list transaction)
  ~&  %assuming-lockup-done-by-ceremony
  ~&  %assuming-ceremony-controls-parents
  =.  what  ::  expand galaxies into stars
    %-  zing
    %+  turn  what
    |=  s=ship
    ^-  (list ship)
    ?.  =(%czar (clan:title s))  [s]~
    (turn (gulf 1 255) |=(k=@ud (cat 3 s k)))
  =/  parents
    =-  ~(tap in -)
    %+  roll  what
    |=  [s=ship ss=(set ship)]
    ?>  =(%king (clan:title s))
    (~(put in ss) (^sein:title s))
  ~|  %invalid-lockup-ships
  ?>  ~|  %does-this-also-work
      ?|  ?=(%linear -.lockup)
          =(`@`(lent what) :(add b1.lockup b2.lockup b3.lockup))
      ==
  =/  contract=address
    ?-  -.lockup
      %linear       0x86cd.9cd0.992f.0423.1751.e376.1de4.5cec.ea5d.1801
      %conditional  0x8c24.1098.c3d3.498f.e126.1421.633f.d579.86d7.4aea
    ==
  =|  txs=(list transaction)
  |^
    ?^  parents
      =.  txs
        %-  do-here
        (set-spawn-proxy:dat i.parents contract)
      $(parents t.parents)
    =.  txs
      %-  do-here
      ?-  -.lockup
        %linear       (register-linear to (lent what) +.lockup)
        %conditional  (register-conditional to +.lockup)
      ==
    |-
    ?~  what  (flop txs)
    =.  txs
      %-  do-here
      (deposit:dat to i.what)
    $(what t.what)
  ::TODO  maybe-do, take dat gat and unit argument
  ++  do-here
    |=  dat=tape
    :_  txs
    (do network (add nonce (lent txs)) contract dat)
  --
::
++  register-linear
  |=  [to=address stars=@ud windup-years=@ud unlock-years=@ud]
  %-  register-linear:dat
  :*  to
      (mul windup-years yer:yo)
      stars
      (div (mul unlock-years yer:yo) stars)
      1
  ==
::
++  register-conditional
  |=  [to=address [b1=@ud b2=@ud b3=@ud] unlock-years-per-batch=@ud]
  %-  register-conditional:dat
  =-  [`address`to b1 b2 b3 `@ud`- 1]
  (div (mul unlock-years-per-batch yer:yo) :(add b1 b2 b3))
::
::  call data generation
::TODO  most of these should later be cleaned and go in ++constitution
::
++  dat
  |%
  ++  enc
    |*  cal=$-(* call-data)
    (cork cal encode-call)
  ::
  ++  create-galaxy           (enc create-galaxy:cal)
  ++  spawn                   (enc spawn:cal)
  ++  configure-keys          (enc configure-keys:cal)
  ++  set-spawn-proxy         (enc set-spawn-proxy:cal)
  ++  transfer-ship           (enc transfer-ship:cal)
  ++  set-management-proxy    (enc set-management-proxy:cal)
  ++  set-voting-proxy        (enc set-voting-proxy:cal)
  ++  set-transfer-proxy      (enc set-transfer-proxy:cal)
  ++  set-dns-domains         (enc set-dns-domains:cal)
  ++  upgrade-to              (enc upgrade-to:cal)
  ++  transfer-ownership      (enc transfer-ownership:cal)
  ++  register-linear         (enc register-linear:cal)
  ++  register-conditional    (enc register-conditional:cal)
  ++  deposit                 (enc deposit:cal)
  --
::
++  cal
  |%
  ++  create-galaxy
    |=  [gal=ship to=address]
    ^-  call-data
    ?>  =(%czar (clan:title gal))
    :-  'createGalaxy(uint8,address)'
    ^-  (list data)
    :~  [%uint `@`gal]
        [%address to]
    ==
  ::
  ++  spawn
    |=  [who=ship to=address]
    ^-  call-data
    ?>  ?=(?(%king %duke) (clan:title who))
    :-  'spawn(uint32,address)'
    :~  [%uint `@`who]
        [%address to]
    ==
  ::
  ++  configure-keys
    |=  [who=ship crypt=@ auth=@]
    ::TODO  maybe disable asserts?
    ?>  (lte (met 3 crypt) 32)
    ?>  (lte (met 3 auth) 32)
    :-  'configureKeys(uint32,bytes32,bytes32,uint32,bool)'
    :~  [%uint `@`who]
        [%bytes-n 32^crypt]
        [%bytes-n 32^auth]
        [%uint 1]
        [%bool |]
    ==
  ::
  ++  set-management-proxy
    |=  [who=ship proxy=address]
    ^-  call-data
    :-  'setManagementProxy(uint32,address)'
    :~  [%uint `@`who]
        [%address proxy]
    ==
  ::
  ++  set-voting-proxy
    |=  [who=ship proxy=address]
    ^-  call-data
    :-  'setVotingProxy(uint8,address)'
    :~  [%uint `@`who]
        [%address proxy]
    ==
  ::
  ++  set-spawn-proxy
    |=  [who=ship proxy=address]
    ^-  call-data
    :-  'setSpawnProxy(uint16,address)'
    :~  [%uint `@`who]
        [%address proxy]
    ==
  ::
  ++  transfer-ship
    |=  [who=ship to=address]
    ^-  call-data
    :-  'transferPoint(uint32,address,bool)'
    :~  [%uint `@`who]
        [%address to]
        [%bool |]
    ==
  ::
  ++  set-transfer-proxy
    |=  [who=ship proxy=address]
    ^-  call-data
    :-  'setTransferProxy(uint32,address)'
    :~  [%uint `@`who]
        [%address proxy]
    ==
  ::
  ++  set-dns-domains
    |=  [pri=tape sec=tape ter=tape]
    ^-  call-data
    :-  'setDnsDomains(string,string,string)'
    :~  [%string pri]
        [%string sec]
        [%string ter]
    ==
  ::
  ++  upgrade-to
    |=  to=address
    ^-  call-data
    :-  'upgradeTo(address)'
    :~  [%address to]
    ==
  ::
  ::
  ++  transfer-ownership  ::  of contract
    |=  to=address
    ^-  call-data
    :-  'transferOwnership(address)'
    :~  [%address to]
    ==
  ::
  ::
  ++  register-linear
    |=  $:  to=address
            windup=@ud
            stars=@ud
            rate=@ud
            rate-unit=@ud
        ==
    ^-  call-data
    ~&  [%register-linear stars to]
    :-  'register(address,uint256,uint16,uint16,uint256)'
    :~  [%address to]
        [%uint windup]
        [%uint stars]
        [%uint rate]
        [%uint rate-unit]
    ==
  ::
  ++  register-conditional
    |=  $:  to=address
            b1=@ud
            b2=@ud
            b3=@ud
            rate=@ud
            rate-unit=@ud
        ==
    ^-  call-data
    :-  'register(address,uint16[],uint16,uint256)'
    :~  [%address to]
        [%array ~[uint+b1 uint+b2 uint+b3]]
        [%uint rate]
        [%uint rate-unit]
    ==
  ::
  ++  deposit
    |=  [to=address star=ship]
    ^-  call-data
    :-  'deposit(address,uint16)'
    :~  [%address to]
        [%uint `@`star]
    ==
  --
::
:: ++  peer-sole
::   |=  =path
::   =.  id.cli  ost.bowl
::   TODO...
:: ::
:: ++  sh
::   |_  she=shell
::   ::
::   ::  #  %resolve
::   +|  %resolve
::   ::
::   ++  sh-done
::     ::  stores changes to the cli.
::     ::
::     ^+  +>
::     +>(cli she)
::   ::
::   ::  #
::   ::  #  %emitters
::   ::  #
::   ::    arms that create outward changes.
::   +|  %emitters
::   ::
::   ++  sh-fact
::     ::  adds a console effect to ++ta's moves.
::     ::
::     |=  fec/sole-effect:sole-sur
::     ^+  +>
::     +>(moves [[id.she %diff %sole-effect fec] moves])
::   ::
::   ++  sh-prod
::     ::    show prompt
::     ::
::     ::  makes and stores a move to modify the cli
::     ::  prompt to display the current audience.
::     ::
::     ^+  .
::     %+  sh-fact  %pro
::     :+  &  %talk-line
::     ^-  tape
::     =/  rew/(pair (pair cord cord) audience)
::         [['[' ']'] active.she]
::     =+  cha=(~(get by bound) q.rew)
::     ?^  cha  ~[u.cha ' ']
::     =+  por=~(ar-prom ar q.rew)
::     (weld `tape`[p.p.rew por] `tape`[q.p.rew ' ' ~])
::   ::
::   --
--