::  clay (4c), revision control
!:
::  This is split in three top-level sections:  structure definitions, main
::  logic, and arvo interface.
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::  Here are the structures.  `++raft` is the formal arvo state.  It's also
::  worth noting that many of the clay-related structures are defined in zuse.
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
|=  pit/vase
=,  clay
=>  |%
+$  aeon  @ud                                           ::  version number
::
::  Recursive structure of a desk's data.
::
::  We keep an ankh only for the current version of local desks.  Everywhere
::  else we store it as (map path lobe).
::
+$  ankh                                                ::  expanded node
  $~  [~ ~]
  $:  fil/(unit {p/lobe q/cage})                        ::  file
      dir/(map @ta ankh)                                ::  folders
  ==                                                    ::
::
::  Part of ++mery, representing the set of changes between the mergebase and
::  one of the desks being merged.
::
::  --  `new` is the set of files in the new desk and not in the mergebase.
::  --  `cal` is the set of changes in the new desk from the mergebase except
::      for any that are also in the other new desk.
::  --  `can` is the set of changes in the new desk from the mergebase and that
::      are also in the other new desk (potential conflicts).
::  --  `old` is the set of files in the mergebase and not in the new desk.
::
+$  cane
  $:  new/(map path lobe)
      cal/(map path lobe)
      can/(map path cage)
      old/(map path ~)
  ==
::
::  Type of request.
::
::  %d produces a set of desks, %p gets file permissions, %u checks for
::  existence, %v produces a ++dome of all desk data, %w gets @ud and @da
::  variants for the given case, %x gets file contents, %y gets a directory
::  listing, and %z gets a recursive hash of the file contents and children.
::
:: ++  care  ?($d $p $u $v $w $x $y $z)
::
::  Keeps track of subscribers.
::
::  A map of requests to a set of all the subscribers who should be notified
::  when the request is filled/updated.
::
+$  cult  (jug wove duct)
::
::  Domestic desk state.
::
::  Includes subscriber list, dome (desk content), possible commit state (for
::  local changes), possible merge state (for incoming merges), and permissions.
::
++  dojo
  $:  qyx/cult                                          ::  subscribers
      dom/dome                                          ::  desk state
      per/regs                                          ::  read perms per path
      pew/regs                                          ::  write perms per path
  ==
::
::  Desk state.
::
::  Includes a checked-out ankh with current content, most recent version, map
::  of all version numbers to commit hashes (commits are in hut.rang), and map
::  of labels to version numbers.
::
::  `mim` is a cache of the content in the directories that are mounted
::  to unix.  Often, we convert to/from mime without anything really
::  having changed; this lets us short-circuit that in some cases.
::  Whenever you give an `%ergo`, you must update this.
::
++  dome
  $:  ank/ankh                                          ::  state
      let/aeon                                          ::  top id
      hit/(map aeon tako)                               ::  versions by id
      lab/(map @tas aeon)                               ::  labels
      mim/(map path mime)                               ::  mime cache
  ==                                                    ::
::
::  Commit state.
::
::  --  `del` is the paths we're deleting.
::  --  `ink` is the insertions of hoon files (short-circuited for
::      bootstrapping).
::  --  `ins` is all the other insertions.
::  --  `dif` is the diffs in `dig` applied to their files.
::  --  `mut` is the diffs between `muc` and the original files.
::
++  dork                                                ::  diff work
  $:  del/(list path)                                   ::  deletes
      ink/(list (pair path cage))                       ::  hoon inserts
      ins/(list (pair path cage))                       ::  inserts
      dif/(list (trel path lobe cage))                  ::  changes
      mut/(list (trel path lobe cage))                  ::  mutations
  ==                                                    ::
::
::  Hash of a blob, for lookup in the object store (lat.ran)
::
++  lobe  @uvI                                          ::  blob ref
::
::  New desk data.
::
::  Sent to other ships to update them about a particular desk.  Includes a map
::  of all new aeons to hashes of their commits, the most recent aeon, and sets
::  of all new commits and data.
::
++  nako                                                ::  subscription state
  $:  gar/(map aeon tako)                               ::  new ids
      let/aeon                                          ::  next id
      lar/(set yaki)                                    ::  new commits
      bar/(set plop)                                    ::  new content
  ==                                                    ::
::
::  Formal vane state.
::
::  --  `rom` is our domestic state.
::  --  `hoy` is a collection of foreign ships where we know something about
::      their clay.
::  --  `ran` is the object store.
::  --  `mon` is a collection of mount points (mount point name to urbit
::      location).
::  --  `hez` is the unix duct that %ergo's should be sent to.
::  --  `cez` is a collection of named permission groups.
::  --  `cue` is a queue of requests to perform in later events.
::  --  `tip` is the date of the last write; if now, enqueue incoming requests.
::
++  raft                                                ::  filesystem
  $:  rom=room                                          ::  domestic
      hoy=(map ship rung)                               ::  foreign
      ran=rang                                          ::  hashes
      mon=(map term beam)                               ::  mount points
      hez=(unit duct)                                   ::  sync duct
      cez=(map @ta crew)                                ::  permission groups
      cue=(qeu [=duct =task:able])                      ::  queued requests
      act=active-write                                  ::  active write
  ==                                                    ::
::
::  Currently active write
::
++  active-write
  %-  unit
  $:  hen=duct
      req=task:able
      $=  eval-data
      $%  [%commit commit=eval-form:eval:commit-clad]
          [%merge merge=eval-form:eval:merge-clad]
      ==
  ==
::
::  The clad monad for commits.
::
::  --  `dome` is the new dome -- each writer has a lock on the dome for
::      that desk
::  --  `rang` is a superset of the global rang, but we uni:by it into
::      the global rang because other things might add stuff to it.
::      Thus, writers do *not* have a lock on the global rang.
::
++  commit-clad  (clad ,[dome rang])
::
::  The clad monad for merges.
::
::  Same as +commit-clad, except includes a set of paths documenting the
::  conflicts encountered in the merge.
::
++  merge-clad  (clad ,[(set path) dome rang])
::
::  Object store.
::
::  Maps of commit hashes to commits and content hashes to content.
::
++  rang                                                ::
  $:  hut/(map tako yaki)                               ::
      lat/(map lobe blob)                               ::
  ==                                                    ::
::
::  Unvalidated response to a request.
::
::  Like a ++rant, but with a page of data rather than a cage of it.
::
++  rand                                                ::  unvalidated rant
          $:  p/{p/care q/case r/@tas}                  ::  clade release book
              q/path                                    ::  spur
              r/page                                    ::  data
          ==                                            ::
::
::  Generic desk state.
::
::  --  `lim` is the most recent date we're confident we have all the
::      information for.  For local desks, this is always `now`.  For foreign
::      desks, this is the last time we got a full update from the foreign
::      urbit.
::  --  `ref` is a possible request manager.  For local desks, this is null.
::      For foreign desks, this keeps track of all pending foreign requests
::      plus a cache of the responses to previous requests.
::  --  `qyx` is the set of subscriptions, with listening ducts. These
::      subscriptions exist only until they've been filled.
::  --  `dom` is the actual state of the filetree.  Since this is used almost
::      exclusively in `++ze`, we describe it there.
::
++  rede                                                ::  universal project
          $:  lim/@da                                   ::  complete to
              ref/(unit rind)                           ::  outgoing requests
              qyx/cult                                  ::  subscribers
              dom/dome                                  ::  revision state
              per/regs                                  ::  read perms per path
              pew/regs                                  ::  write perms per path
          ==                                            ::
::
::  Foreign request manager.
::
::  When we send a request to a foreign ship, we keep track of it in here.  This
::  includes a request counter, a map of request numbers to requests, a reverse
::  map of requesters to request numbers, a simple cache of common %sing
::  requests, and a possible nako if we've received data from the other ship and
::  are in the process of validating it.
::
++  rind                                                ::  request manager
          $:  nix/@ud                                   ::  request index
              bom/(map @ud {p/duct q/rave})             ::  outstanding
              fod/(map duct @ud)                        ::  current requests
              haw/(map mood (unit cage))                ::  simple cache
              nak/(unit nako)                           ::  pending validation
          ==                                            ::
::
::  Domestic ship.
::
::  `hun` is the duct to dill, and `dos` is a collection of our desks.
::
++  room                                                ::  fs per ship
          $:  hun/duct                                  ::  terminal duct
              dos/(map desk dojo)                       ::  native desk
          ==                                            ::
::
::  Stored request.
::
::  Like a ++rave but with caches of current versions for %next and %many.
::  Generally used when we store a request in our state somewhere.
::
++  cach  (unit (unit (each cage lobe)))                ::  cached result
++  wove  {p/(unit ship) q/rove}                        ::  stored source + req
++  rove                                                ::  stored request
          $%  {$sing p/mood}                            ::  single request
              {$next p/mood q/(unit aeon) r/cach}       ::  next version of one
              $:  $mult                                 ::  next version of any
                  p/mool                                ::  original request
                  q/(unit aeon)                         ::  checking for change
                  r/(map (pair care path) cach)         ::  old version
                  s/(map (pair care path) cach)         ::  new version
              ==                                        ::
              {$many p/? q/moat r/(map path lobe)}      ::  change range
          ==                                            ::
::
::  Foreign desk data.
::
++  rung
          $:  rit=rift                                  ::  lyfe of 1st contact
              rus=(map desk rede)                       ::  neighbor desks
          ==
::
::  Hash of a commit, for lookup in the object store (hut.ran)
::
++  tako  @                                             ::  yaki ref
::
::  Merge state.
::
++  wait  $?  $null   $ali    $diff-ali   $diff-bob     ::  what are we
              $merge  $build  $checkout   $ergo         ::  waiting for?
          ==                                            ::
::
::  Commit.
::
::  List of parents, content, hash of self, and time commited.
::
++  yaki                                                ::  snapshot
          $:  p/(list tako)                             ::  parents
              q/(map path lobe)                         ::  fileset
              r/tako                                    ::
          ::                                            ::  XX s?
              t/@da                                     ::  date
          ==                                            ::
::
::  Unvalidated blob
::
++  plop  blob                                          ::  unvalidated blob
::
::  The clay monad, for easier-to-follow state machines.
::
::  The best way to think about a clad is that it's a transaction that
::  may take multiple arvo events, and may send notes to other vanes to
::  get information.
::
+$  clad-input  [now=@da new-rang=rang =sign]
::
::  notes:   notes to send immediately.  These will go out even if a
::           later stage of the process fails, so they shouldn't have any
::           semantic effect on the rest of the system.  Path is
::           included exclusively for documentation and |verb.
::  effects: moves to send after the process ends.
::  wait:    don't move on, stay here.  The next sign should come back
::           to this same callback.
::  cont:    continue process with new callback.
::  fail:    abort process; don't send effects
::  done:    finish process; send effects
::
++  clad-output-raw
  |*  a=mold
  $~  [~ ~ %done *a]
  $:  notes=(list [path note])
      effects=(list move)
      $=  next
      $%  [%wait ~]
          [%cont self=(clad-form-raw a)]
          [%fail err=(pair term tang)]
          [%done value=a]
      ==
  ==
::
++  clad-form-raw
  |*  a=mold
  $-(clad-input (clad-output-raw a))
::
++  clad-fail
  |=  err=(pair term tang)
  |=  clad-input
  [~ ~ %fail err]
::
++  clad
  |*  a=mold
  |%
  ++  output  (clad-output-raw a)
  ++  form  (clad-form-raw a)
  ++  pure
    |=  arg=a
    ^-  form
    |=  clad-input
    [~ ~ %done arg]
  ::
  ++  bind
    |*  b=mold
    |=  [m-b=(clad-form-raw b) fun=$-(b form)]
    ^-  form
    |=  input=clad-input
    =/  b-res=(clad-output-raw b)
      (m-b input)
    ^-  output
    :+  notes.b-res  effects.b-res
    ?-    -.next.b-res
      %wait  [%wait ~]
      %cont  [%cont ..$(m-b self.next.b-res)]
      %fail  [%fail err.next.b-res]
      %done  [%cont (fun value.next.b-res)]
    ==
  ::
  ::  The clad monad must be evaluted in a particular way to maintain
  ::  its monadic character.  +take:eval implements this.
  ::
  ++  eval
    |%
    ::  Indelible state of a clad
    ::
    +$  eval-form
      $:  effects=(list move)
          =form
      ==
    ::
    ::  The cases of results of +take
    ::
    +$  eval-result
      $%  [%next ~]
          [%fail err=(pair term tang)]
          [%done value=a]
      ==
    ::
    ::  Take a new sign and run the clad against it
    ::
    ++  take
      ::  moves: accumulate throughout recursion the moves to be
      ::         produced now
      =|  moves=(list move)
      |=  [=eval-form =duct =our=wire =clad-input]
      ^-  [[(list move) =eval-result] _eval-form]
      ::  run the clad callback
      ::
      =/  =output  (form.eval-form clad-input)
      ::  add notes to moves
      ::
      =.  moves
        %+  welp
          moves
        %+  turn  notes.output
        |=  [=path =note]
        [duct %pass (weld our-wire path) note]
      ::  add effects to list to be produced when done
      ::
      =.  effects.eval-form
        (weld effects.eval-form effects.output)
      ::  if done, produce effects
      ::
      =?  moves  ?=(%done -.next.output)
        %+  welp
          moves
        effects.eval-form
      ::  case-wise handle next steps
      ::
      ?-  -.next.output
          %wait  [[moves %next ~] eval-form]
          %fail  [[moves %fail err.next.output] eval-form]
          %done  [[moves %done value.next.output] eval-form]
          %cont
        ::  recurse to run continuation with initialization move
        ::
        %_  $
          form.eval-form   self.next.output
          sign.clad-input  [%y %init-clad ~]
        ==
      ==
    --
  --
::
++  move  {p/duct q/(wind note gift:able)}              ::  local move
++  note                                                ::  out request $->
  $%  $:  $a                                            ::  to %ames
  $%  {$want p/ship q/path r/*}                         ::
  ==  ==                                                ::
      $:  $c                                            ::  to %clay
  $%  {$info q/@tas r/nori}                             ::  internal edit
      {$merg p/@tas q/@p r/@tas s/case t/germ:clay}     ::  merge desks
      {$warp p/ship q/riff}                             ::
      {$werp p/ship q/ship r/riff}                      ::
  ==  ==                                                ::
      $:  $d                                            ::  to %dill
  $%  $:  $flog                                         ::
          $%  {$crud p/@tas q/(list tank)}              ::
              {$text p/tape}                            ::
      ==  ==                                            ::
  ==  ==                                                ::
      $:  $f                                            ::
  $%  [%build live=? schematic=schematic:ford]          ::
      [%keep compiler-cache=@ud build-cache=@ud]        ::
      [%wipe percent-to-remove=@ud]                     ::
  ==  ==                                                ::
      $:  $b                                            ::
  $%  {$wait p/@da}                                     ::
      {$rest p/@da}                                     ::
      {$drip p/vase}                                    ::
  ==  ==  ==                                            ::
++  riot  (unit rant)                                   ::  response+complete
++  sign                                                ::  in result $<-
          $%  $:  %y
          $%  {$init-clad ~}
          ==  ==
              $:  $a                                    ::  by %ames
          $%  {$woot p/ship q/coop}                     ::
              {$send p/lane:ames q/@}                   ::  transmit packet
          ==  ==                                        ::
              $:  %b
          $%  {$writ p/riot}                            ::
          ==  ==
              $:  $c                                    ::  by %clay
          $%  {$note p/@tD q/tank}                      ::
              {$mere p/(each (set path) (pair term tang))}
              {$writ p/riot}                            ::
          ==  ==                                        ::
              $:  $f                                    ::
          $%  [%made date=@da result=made-result:ford]  ::
          ==  ==                                        ::
              $:  $b                                    ::
          $%  {$wake error=(unit tang)}                 ::  timer activate
          ==  ==                                        ::
              $:  @tas                                  ::  by any
          $%  {$crud p/@tas q/(list tank)}              ::
          ==  ==  ==                                    ::
--
::
::  Old state types for ++load
::
=>  |%
+$  raft-1  raft
--  =>
::  %utilities
::
|%
::  +sort-by-head: sorts alphabetically using the head of each element
::
++  sort-by-head
  |=([a=(pair path *) b=(pair path *)] (aor p.a p.b))
::
::  Just send a note.
::
++  just-do
  |=  [=path =note]
  =/  m  (clad ,~)
  ^-  form:m
  |=  clad-input
  [[path note]~ ~ %done ~]
::
::  Wait for ford to respond
::
++  expect-ford
  =/  m  (clad ,made-result:ford)
  ^-  form:m
  |=  clad-input
  ?:  ?=(%init-clad +<.sign)
    [~ ~ %wait ~]
  ?:  ?=(%made +<.sign)
    [~ ~ %done result.sign]
  ~|  [%expected-made got=+<.sign]
  !!
::
::  Wait for clay to respond
::
::    This setup where we take in a new-rang in +clad-input but only
::    apply it when calling +expect-clay is suspicious.  I'm not sure
::    what's the best approach to reading in potentially new state that
::    we also may have changed but haven't committed.
::
++  expect-clay
  |=  ran=rang
  =/  m  (clad ,[riot rang])
  ^-  form:m
  |=  clad-input
  ?:  ?=(%init-clad +<.sign)
    [~ ~ %wait ~]
  ?:  ?=(%writ +<.sign)
    =/  uni-rang=rang
      :-  (~(uni by hut.ran) hut.new-rang)
      (~(uni by lat.ran) lat.new-rang)
    [~ ~ %done p.sign uni-rang]
  ~|  [%expected-writ got=+<.sign]
  !!
--  =>
|%
::
::  Make a new commit with the given +nori of changes.
::
++  commit
  ::  Global constants.  These do not change during a commit.
  ::
  |=  $:  our=ship
          syd=desk
          wen=@da
          mon=(map term beam)
          hez=(unit duct)
          hun=duct
      ==
  |^
  ::  Initial arguments
  ::
  |=  [lem=nori original-dome=dome ran=rang]
  =/  m  commit-clad
  ^-  form:m
  ?:  ?=(%| -.lem)
    ::  If the change is just adding a label, handle it directly.
    ::
    =.  original-dome
      (execute-label:(state:util original-dome original-dome ran) p.lem)
    =/  e  (cor original-dome ran)
    ;<  ~  bind:m  (print-changes:e %| p.lem)
    (pure:m dom:e ran:e)
  ::
  ::  Else, collect the data, apply it, fill in our local cache, let
  ::  unix know, and print a notification to the screen.
  ::
  =/  e  (cor original-dome ran)
  ;<  [=dork mim=(map path mime)]  bind:m  (fill-dork:e wen p.lem)
  ;<  [=suba e=_*cor]              bind:m  (apply-dork:e wen dork)
  ;<  e=_*cor                      bind:m  checkout-new-state:e
  ;<  mim=(map path mime)          bind:m  (ergo-changes:e suba mim)
  ;<  ~                            bind:m  (print-changes:e %& suba)
  =.  mim.dom.e  mim
  (pure:m dom:e ran:e)
  ::
  ::  A stateful core, where the global state is a dome and a rang.
  ::
  ::    These are the global state variables that an edit may change.
  ::
  ++  cor
    |=  [dom=dome ran=rang]
    =/  original-dome  dom
    |%
    ++  this-cor  .
    ++  sutil  (state:util original-dome dom ran)
    ::
    ::  Collect all the insertions, deletions, diffs, and mutations
    ::  which are requested.
    ::
    ::  Sends them through ford for casting, patching, and diffing so
    ::  that the produced dork has all the relevant cages filled in.
    ::
    ::  Also fills in the mime cache.  Often we need to convert to mime
    ::  anyway to send (back) to unix, so we just keep it around rather
    ::  than recalculating it.  This is less necessary than before
    ::  because of the ford cache.
    ::
    ++  fill-dork
      |=  [wen=@da =soba]
      =/  m  (clad ,[=dork mim=(map path mime)])
      ^-  form:m
      =|  $=  nuz
          $:  del=(list (pair path miso))
              ins=(list (pair path miso))
              dif=(list (pair path miso))
              mut=(list (pair path miso))
              ink=(list (pair path miso))
          ==
      ::
      =.  nuz
        |-  ^+  nuz
        ?~  soba  nuz
        ::
        ?-    -.q.i.soba
            %del  $(soba t.soba, del.nuz [i.soba del.nuz])
            %dif  $(soba t.soba, dif.nuz [i.soba dif.nuz])
            %ins
          =/  pax=path  p.i.soba
          =/  mar=mark  p.p.q.i.soba
          ::
          ::  We store `%hoon` files directly to `ink` so that we add
          ::  them without requiring any mark definitions.  `%hoon`
          ::  files have to be treated specially to make the
          ::  bootstrapping sequence work, since the mark definitions
          ::  are themselves `%hoon` files.
          ::
          ?:  ?&  ?=([%hoon *] (flop pax))
                  ?=(%mime mar)
              ==
            $(soba t.soba, ink.nuz [i.soba ink.nuz])
          $(soba t.soba, ins.nuz [i.soba ins.nuz])
        ::
            %mut
          =/  pax=path  p.i.soba
          =/  mis=miso  q.i.soba
          ?>  ?=(%mut -.mis)
          =/  cag=cage  p.mis
          ::  if :mis has the %mime mark and it's the same as cached, no-op
          ::
          ?:  ?.  =(%mime p.cag)
                %.n
              ?~  cached=(~(get by mim.dom) pax)
                %.n
              =(q:;;(mime q.q.cag) q.u.cached)
            ::
            $(soba t.soba)
          ::  if the :mis mark is the target mark and the value is the same, no-op
          ::
          ?:  =/  target-mark=mark  =+(spur=(flop pax) ?~(spur !! i.spur))
              ?.  =(target-mark p.cag)
                %.n
              ::
              =/  stored  (need (need (read-x:sutil & let.dom pax)))
              =/  stored-cage=cage  ?>(?=(%& -.stored) p.stored)
              ::
              =(q.q.stored-cage q.q.cag)
            ::
            $(soba t.soba)
          ::  the value differs from what's stored, so register mutation
          ::
          $(soba t.soba, mut.nuz [i.soba mut.nuz])
        ==
      ::  sort each section alphabetically for determinism
      ::
      =.  nuz  :*
        (sort del.nuz sort-by-head)
        (sort ins.nuz sort-by-head)
        (sort dif.nuz sort-by-head)
        (sort mut.nuz sort-by-head)
        (sort ink.nuz sort-by-head)
      ==
      =/  ink
         %+  turn  ink.nuz
         |=  {pax/path mis/miso}
         ^-  (pair path cage)
         ?>  ?=($ins -.mis)
         =+  =>((flop pax) ?~(. %$ i))
         [pax - [%atom %t ~] ;;(@t +>.q.q.p.mis)]
      ::
      =/  mim
        ::  add the new files to the new mime cache
        ::
        %-  malt
        ^-  (list (pair path mime))
        ;:  weld
          ^-  (list (pair path mime))
          %+  murn  ins.nuz
          |=  {pax/path mis/miso}
          ^-  (unit (pair path mime))
          ?>  ?=($ins -.mis)
          ?.  ?=($mime p.p.mis)
            ~
          `[pax ;;(mime q.q.p.mis)]
        ::
          ^-  (list (pair path mime))
          %+  murn  ink.nuz
          |=  {pax/path mis/miso}
          ^-  (unit (pair path mime))
          ?>  ?=($ins -.mis)
          ?>  ?=($mime p.p.mis)
          `[pax ;;(mime q.q.p.mis)]
        ::
          ^-  (list (pair path mime))
          %+  murn  mut.nuz
          |=  {pax/path mis/miso}
          ^-  (unit (pair path mime))
          ?>  ?=($mut -.mis)
          ?.  ?=($mime p.p.mis)
            ~
          `[pax ;;(mime q.q.p.mis)]
        ==
      ::
      ;<  ins=(list (pair path cage))       bind:m  (calc-inserts wen ins.nuz)
      ;<  dif=(list (trel path lobe cage))  bind:m  (calc-diffs wen dif.nuz)
      ;<  mut=(list (trel path lobe cage))  bind:m  (calc-mutates wen mut.nuz)
      %+  pure:m
        ^-  dork
        [del=(turn del.nuz head) ink ins dif mut]
      mim
    ::
    ::  Build the list of insertions by casting to the correct mark.
    ::
    ++  calc-inserts
      |=  [wen=@da ins=(list (pair path miso))]
      =/  m  (clad (list (pair path cage)))
      ^-  form:m
      ;<  ~  bind:m
        %+  just-do  /inserts
        :*  %f  %build  live=%.n  %pin  wen  %list
            ^-  (list schematic:ford)
            %+  turn  ins
            |=  [pax=path mis=miso]
            ?>  ?=($ins -.mis)
            :-  [%$ %path -:!>(*path) pax]
            =+  =>((flop pax) ?~(. %$ i))
            [%cast [our syd] - [%$ p.mis]]
        ==
      ;<  res=made-result:ford  bind:m  expect-ford
      ^-  form:m
      |=  clad-input
      :^  ~  ~  %done
      ^-  (list (pair path cage))
      %+  turn  (made-result-to-success-cages:util res)
      |=  {pax/cage cay/cage}
      ?.  ?=($path p.pax)
        ~|(%clay-take-inserting-strange-path-mark !!)
      [;;(path q.q.pax) cay]
    ::
    ::  Build the list of diffs by apply the given diffs to the existing
    ::  data.
    ::
    ++  calc-diffs
      |=  [wen=@da dif=(list (pair path miso))]
      =/  m  (clad (list (trel path lobe cage)))
      ^-  form:m
      ;<  ~  bind:m
        %+  just-do  /diffs
        :*  %f  %build  live=%.n  %pin  wen  %list
            ^-  (list schematic:ford)
            %+  turn  dif
            |=  {pax/path mis/miso}
            ?>  ?=($dif -.mis)
            =+  (need (need (read-x:sutil & let.dom pax)))
            ?>  ?=(%& -<)
            :-  [%$ %path -:!>(*path) pax]
            [%pact [our syd] [%$ p.-] [%$ p.mis]]
        ==
      ;<  res=made-result:ford  bind:m  expect-ford
      ^-  form:m
      |=  clad-input
      :^  ~  ~  %done
      ^-  (list (trel path lobe cage))
      =/  dig=(map path cage)
        %-  malt
        (turn dif |=({pax/path mis/miso} ?>(?=($dif -.mis) [pax p.mis])))
      %+  turn  (made-result-to-cages:util res)
      |=  {pax/cage cay/cage}
      ^-  (pair path (pair lobe cage))
      ?.  ?=($path p.pax)
        ~|(%clay-take-diffing-strange-path-mark !!)
      =+  paf=;;(path q.q.pax)
      [paf (page-to-lobe:sutil [p q.q]:cay) (~(got by dig) paf)]
    ::
    ::  Build the list of mutations by casting to the correct mark and
    ::  diffing against the existing data.
    ::
    ++  calc-mutates
      |=  [wen=@da mut=(list (pair path miso))]
      =/  m  (clad (list (trel path lobe cage)))
      ^-  form:m
      ;<  ~  bind:m
        %+  just-do  /casts
        :*  %f  %build  live=%.n  %pin  wen  %list
            ::~  [her syd %da wen]  %tabl
            ^-  (list schematic:ford)
            %+  turn  mut
            |=  {pax/path mis/miso}
            ?>  ?=($mut -.mis)
            :-  [%$ %path -:!>(*path) pax]
            =/  mar
              %-  lobe-to-mark:sutil
              (~(got by q:(aeon-to-yaki:sutil let.dom)) pax)
            [%cast [our syd] mar [%$ p.mis]]
        ==
      ;<  res=made-result:ford    bind:m  expect-ford
      ;<  hashes=(map path lobe)  bind:m
        |=  clad-input
        =+  ^-  cat/(list (pair path cage))
            %+  turn  (made-result-to-cages:util res)
            |=  {pax/cage cay/cage}
            ?.  ?=($path p.pax)
              ~|(%castify-bad-path-mark !!)
            [;;(path q.q.pax) cay]
        :_  :+  ~  %done
            ^-  (map path lobe)
            %-  malt
            %+  turn  cat
            |=  {pax/path cay/cage}
            [pax (page-to-lobe:sutil [p q.q]:cay)]
        ^-  (list [path note])
        :_  ~
        :*  /mutates
            %f  %build  live=%.n  %pin  wen  %list
            ^-  (list schematic:ford)
            %+  turn  cat
            |=  {pax/path cay/cage}
            :-  [%$ %path -:!>(*path) pax]
            =/  scheme
              %^  lobe-to-schematic:sutil  [our syd]  pax
              (~(got by q:(aeon-to-yaki:sutil let.dom)) pax)
            [%diff [our syd] scheme [%$ cay]]
        ==
      ;<  res=made-result:ford    bind:m  expect-ford
      %-  pure:m
      ^-  (list (trel path lobe cage))
      %+  murn  (made-result-to-cages:util res)
      |=  {pax/cage cay/cage}
      ^-  (unit (pair path (pair lobe cage)))
      ?.  ?=($path p.pax)
        ~|(%clay-take-mutating-strange-path-mark !!)
      ?:  ?=($null p.cay)
        ~
      =+  paf=;;(path q.q.pax)
      `[paf (~(got by hashes) paf) cay]
    ::
    ::  Collect the relevant data from dok and run +execute-changes to
    ::  apply them to our state.
    ::
    ++  apply-dork
      |=  [wen=@da =dork]
      =/  m  (clad ,[=suba _this-cor])
      ^-  form:m
      =+  ^-  sim=(list (pair path misu))
          ;:  weld
            ^-  (list (pair path misu))
            (turn del.dork |=(pax/path [pax %del ~]))
          ::
            ^-  (list (pair path misu))
            (turn ink.dork |=({pax/path cay/cage} [pax %ins cay]))
          ::
            ^-  (list (pair path misu))
            (turn ins.dork |=({pax/path cay/cage} [pax %ins cay]))
          ::
            ^-  (list (pair path misu))
            (turn dif.dork |=({pax/path cal/{lobe cage}} [pax %dif cal]))
          ::
            ^-  (list (pair path misu))
            (turn mut.dork |=({pax/path cal/{lobe cage}} [pax %dif cal]))
          ==
      =/  res=(unit [=dome =rang])
        (execute-changes:sutil wen sim)
      ?~  res
        (clad-fail %dork-fail ~)
      =:  dom  dome.u.res
          ran  rang.u.res
        ==
      (pure:m sim this-cor)
    ::
    ::  Take the map of paths to lobes, convert to blobs, and save the
    ::  resulting ankh to the dome.
    ::
    ++  checkout-new-state
      =/  m  (clad ,_this-cor)
      ^-  form:m
      ;<  ~  bind:m
        %+  just-do  /checkout
        =/  new-yaki  (aeon-to-yaki:sutil let.dom)
        :*  %f  %build  live=%.n  %list
            ^-  (list schematic:ford)
            %+  turn  (sort ~(tap by q.new-yaki) sort-by-head)
            |=  {a/path b/lobe}
            ^-  schematic:ford
            :-  [%$ %path-hash !>([a b])]
            (lobe-to-schematic:sutil [our syd] a b)
        ==
      ;<  res=made-result:ford  bind:m  expect-ford
      ?.  ?=([%complete %success *] res)
        =/  message  (made-result-as-error:ford res)
        (clad-fail %checkout-fail leaf+"clay patch failed" message)
      ::
      =+  ^-  cat/(list (trel path lobe cage))
          %+  turn  (made-result-to-cages:util res)
          |=  {pax/cage cay/cage}
          ?.  ?=($path-hash p.pax)
            ~|(%patch-bad-path-mark !!)
          [-< -> +]:[;;({path lobe} q.q.pax) cay]
      =.  ank.dom  (map-to-ankh:sutil (malt cat))
      (pure:m this-cor)
    ::
    ::  Choose which changes must be synced to unix, and do so.  We
    ::  convert to mime before dropping the ergo event to unix.
    ::
    ++  ergo-changes
      |=  [=suba mim=(map path mime)]
      =/  m  (clad ,mim=(map path mime))
      ^-  form:m
      ?~  hez  (pure:m mim)
      =+  must=(must-ergo:util our syd mon (turn suba head))
      ?:  =(~ must)
        (pure:m mim)
      =+  ^-  all-paths/(set path)
          %+  roll
            (turn ~(tap by must) (corl tail tail))
          |=  {pak/(set path) acc/(set path)}
          (~(uni in acc) pak)
      =/  changes  (malt suba)
      ;<  ~  bind:m
        %+  just-do  /ergo
        :*  %f  %build  live=%.n  %list
            ^-  (list schematic:ford)
            %+  turn  ~(tap in all-paths)
            |=  a/path
            ^-  schematic:ford
            :-  [%$ %path !>(a)]
            =+  b=(~(got by changes) a)
            ?:  ?=($del -.b)
              [%$ %null !>(~)]
            =+  (~(get by mim) a)
            ?^  -  [%$ %mime !>(u.-)]
            :^  %cast  [our syd]  %mime
            =/  x  (need (need (read-x:sutil & let.dom a)))
            ?:  ?=(%& -<)
              [%$ p.x]
            (lobe-to-schematic:sutil [our syd] a p.x)
        ==
      ;<  res=made-result:ford  bind:m  expect-ford
      ?:  ?=([%incomplete *] res)
        (clad-fail %ergo-fail-incomplete leaf+"clay ergo incomplete" tang.res)
      ?.  ?=([%complete %success *] res)
        (clad-fail %ergo-fail leaf+"clay ergo failed" message.build-result.res)
      =/  changes=(map path (unit mime))
          %-  malt  ^-  mode
          %+  turn  (made-result-to-cages:util res)
          |=  [pax=cage mim=cage]
          ?.  ?=($path p.pax)
            ~|(%ergo-bad-path-mark !!)
          :-  ;;(path q.q.pax)
          ?.  ?=($mime p.mim)
            ~
          `;;(mime q.q.mim)
      =.  mim  (apply-changes-to-mim:util mim changes)
      =+  must=(must-ergo:util our syd mon (turn ~(tap by changes) head))
      ^-  form:m
      |=  clad-input
      :-  ~  :_  [%done mim]
      %+  turn  ~(tap by must)
      |=  {pot/term len/@ud pak/(set path)}
      :*  u.hez  %give  %ergo  pot
          %+  turn  ~(tap in pak)
          |=  pax/path
          [(slag len pax) (~(got by changes) pax)]
      ==
    ::
    ::  Print a summary of changes to dill.
    ::
    ++  print-changes
      |=  lem=nuri
      =/  m  (clad ,~)
      ^-  form:m
      ::  skip full change output for initial filesystem
      ::
      ?:  ?&  =(%base syd)
              |(=(1 let.dom) =(2 let.dom))
              ?=([%& ^] lem)
          ==
        =/  msg=tape
          %+  weld
            "clay: committed initial filesystem"
          ?:(=(1 let.dom) " (hoon)" " (all)")
        |=  clad-input
        :-  ~  :_  [%done ~]
        [hun %pass / %d %flog %text msg]~
      ::
      =+  pre=`path`~[(scot %p our) syd (scot %ud let.dom)]
      ?-  -.lem
          %|  (print-to-dill '=' %leaf :(weld (trip p.lem) " " (spud pre)))
          %&
        |-  ^-  form:m
        ?~  p.lem  (pure:m ~)
        ;<  ~  bind:m
          %+  print-to-dill
            ?-(-.q.i.p.lem $del '-', $ins '+', $dif ':')
          :+  %rose  ["/" "/" ~]
          %+  turn  (weld pre p.i.p.lem)
          |=  a/cord
          ?:  ((sane %ta) a)
            [%leaf (trip a)]
          [%leaf (dash:us (trip a) '\'' ~)]
        ^$(p.lem t.p.lem)
      ==
    ::
    ::  Send a tank straight to dill for printing.
    ::
    ++  print-to-dill
      |=  {car/@tD tan/tank}
      =/  m  (clad ,~)
      ^-  form:m
      |=  clad-input
      :-  ~  :_  [%done ~]
      [hun %give %note car tan]~
    --
  --
::
::  This transaction respresents a currently running merge.  We always
::  say we're merging from 'ali' to 'bob'.  The basic steps, not all of
::  which are always needed, are:
::
::  --  fetch ali's desk
::  --  diff ali's desk against the mergebase
::  --  diff bob's desk against the mergebase
::  --  merge the diffs
::  --  build the new state
::  --  "checkout" (apply to actual `++dome`) the new state
::  --  "ergo" (tell unix about) any changes
::
++  merge
  ::  Global constants.  These do not change during a merge.
  ::
  |=  $:  our=ship
          wen=@da
          ali-disc=(pair ship desk)
          bob-disc=(pair ship desk)
          cas=case
          mon=(map term beam)
          hez=(unit duct)
      ==
  ::  Run ford operations on ali unless it's a foreign desk
  ::
  =/  ford-disc=disc:ford
    ?:  =(p.ali-disc p.bob-disc)
      ali-disc
    bob-disc
  |^
  ::  Initial arguments
  ::
  |=  [gem=germ dom=dome ran=rang]
  =/  m  merge-clad
  ^-  form:m
  =/  e  (cor dom ran)
  ;<  [bob=(unit yaki) gem=germ]  bind:m  (get-bob:e gem)
  ;<  [ali=yaki e=_*cor]          bind:m  fetch-ali:e
  ;<    $=  res
        %-  unit
        $:  conflicts=(set path)
            bop=(map path cage)
            new=yaki
            erg=(map path ?)
            e=_*cor
        ==
      bind:m
    (merge:e gem cas ali bob)
  ?~  res
    ::  if no changes, we're done
    ::
    (pure:m ~ dom:e ran:e)
  =.  e  e.u.res
  ;<  e=_*cor   bind:m     (checkout:e gem cas bob new.u.res bop.u.res)
  ;<  mim=(map path mime)  bind:m  (ergo:e gem cas mon erg.u.res new.u.res)
  =.  mim.dom.e  mim
  (pure:m conflicts.u.res dom:e ran:e)
  ::
  ::  A stateful core, where the global state is a dome and a rang.
  ::
  ::    These are the global state variables that a merge may change.
  ::
  ++  cor
    |=  [dom=dome ran=rang]
    =/  original-dome  dom
    |%
    ++  this-cor  .
    ++  sutil  (state:util original-dome dom ran)
    ::
    ::  Fetch the local disk, if it's there.
    ::
    ++  get-bob
      |=  gem=germ
      =/  m  (clad ,[bob=(unit yaki) gem=germ])
      ^-  form:m
      ?:  &(=(0 let.dom) !?=(?(%init %that) gem))
        (error:he cas %no-bob-disc ~)
      ?:  =(0 let.dom)
        (pure:m ~ %init)
      =/  tak  (~(get by hit.dom) let.dom)
      ?~  tak
        (error:he cas %no-bob-version ~)
      =/  bob  (~(get by hut.ran) u.tak)
      ?~  bob
        (error:he cas %no-bob-commit ~)
      (pure:m `u.bob gem)
    ::
    ::  Tell clay to get the state at the requested case for ali's desk.
    ::
    ++  fetch-ali
      =/  m  (clad ,[ali=yaki e=_this-cor])
      ^-  form:m
      ;<  ~  bind:m
        %+  just-do  /fetch-ali
        [%c %warp p.ali-disc q.ali-disc `[%sing %v cas /]]
      ;<  [rot=riot r=rang]  bind:m  (expect-clay ran)
      =.  ran  r
      ?~  rot
        (error:he cas %bad-fetch-ali ~)
      =/  ali-dome
          ;;  $:  ank=*
                  let=@ud
                  hit=(map @ud tako)
                  lab=(map @tas @ud)
              ==
          q.q.r.u.rot
      ?:  =(0 let.ali-dome)
        (error:he cas %no-ali-disc ~)
      =/  tak  (~(get by hit.ali-dome) let.ali-dome)
      ?~  tak
        (error:he cas %no-ali-version ~)
      =/  ali  (~(get by hut.ran) u.tak)
      ?~  ali
        (error:he cas %no-ali-commit ~)
      (pure:m u.ali this-cor)
    ::
    ::  Produce null if nothing to do; else perform merge
    ::
    ++  merge
      |=  [gem=germ cas=case ali=yaki bob=(unit yaki)]
      =/  m
        %-  clad
        %-  unit
        $:  conflicts=(set path)
            bop=(map path cage)
            new=yaki
            erg=(map path ?)
            e=_this-cor
        ==
      ^-  form:m
      ?-    gem
      ::
      ::  If this is an %init merge, we set the ali's commit to be bob's, and
      ::  we checkout the new state.
      ::
          $init
        %^  pure:m  ~  ~
        :^    ~
            ali
          (~(run by q.ali) |=(lobe %&))
        this-cor(hut.ran (~(put by hut.ran) r.ali ali))
      ::
      ::  If this is a %this merge, we check to see if ali's and bob's commits
      ::  are the same, in which case we're done.  Otherwise, we check to see
      ::  if ali's commit is in the ancestry of bob's, in which case we're
      ::  done.  Otherwise, we create a new commit with bob's data plus ali
      ::  and bob as parents.
      ::
          $this
        =/  bob  (need bob)
        ?:  =(r.ali r.bob)
          (pure:m ~)
        ?:  (~(has in (reachable-takos:sutil r.bob)) r.ali)
          (pure:m ~)
        =/  new  (make-yaki:sutil [r.ali r.bob ~] q.bob wen)
        %^  pure:m  ~  ~
        :^    ~
            new
          ~
        this-cor(hut.ran (~(put by hut.ran) r.new new))
      ::
      ::  If this is a %that merge, we check to see if ali's and bob's commits
      ::  are the same, in which case we're done.  Otherwise, we create a new
      ::  commit with ali's data plus ali and bob as parents.
      ::
          $that
        =/  bob  (need bob)
        ?:  =(r.ali r.bob)
          (pure:m ~)
        =/  new  (make-yaki:sutil [r.ali r.bob ~] q.ali wen)
        %^  pure:m  ~  ~
        :^    ~
            new
          %-  malt  ^-  (list {path ?})
          %+  murn  ~(tap by (~(uni by q.bob) q.ali))
          |=  {pax/path lob/lobe}
          ^-  (unit {path ?})
          =+  a=(~(get by q.ali) pax)
          =+  b=(~(get by q.bob) pax)
          ?:  =(a b)
            ~
          `[pax !=(~ a)]
        this-cor(hut.ran (~(put by hut.ran) r.new new))
      ::
      ::  If this is a %fine merge, we check to see if ali's and bob's commits
      ::  are the same, in which case we're done.  Otherwise, we check to see
      ::  if ali's commit is in the ancestry of bob's, in which case we're
      ::  done.  Otherwise, we check to see if bob's commit is in the ancestry
      ::  of ali's.  If not, this is not a fast-forward merge, so we error
      ::  out.  If it is, we add ali's commit to bob's desk and checkout.
      ::
          $fine
        =/  bob  (need bob)
        ?:  =(r.ali r.bob)
          (pure:m ~)
        ?:  (~(has in (reachable-takos:sutil r.bob)) r.ali)
          (pure:m ~)
        ?.  (~(has in (reachable-takos:sutil r.ali)) r.bob)
          (error:he cas %bad-fine-merge ~)
        %^  pure:m  ~  ~
        :^    ~
            ali
          %-  malt  ^-  (list {path ?})
          %+  murn  ~(tap by (~(uni by q.bob) q.ali))
          |=  {pax/path lob/lobe}
          ^-  (unit {path ?})
          =+  a=(~(get by q.ali) pax)
          =+  b=(~(get by q.bob) pax)
          ?:  =(a b)
            ~
          `[pax !=(~ a)]
        this-cor
      ::
      ::  If this is a %meet, %mate, or %meld merge, we may need to
      ::  fetch more data.  If this merge is either trivial or a
      ::  fast-forward, we short-circuit to either ++done or the %fine
      ::  case.
      ::
      ::  Otherwise, we find the best common ancestor(s) with
      ::  ++find-merge-points.  If there's no common ancestor, we error
      ::  out.  Additionally, if there's more than one common ancestor
      ::  (i.e. this is a criss-cross merge), we error out.  Something
      ::  akin to git's recursive merge should probably be used here,
      ::  but it isn't.
      ::
      ::  Once we have our single best common ancestor (merge base), we
      ::  store it in bas.  If this is a %mate or %meld merge, we diff
      ::  both against the mergebase, merge the conflicts, and build the
      ::  new commit.
      ::
      ::  Otherwise (i.e. this is a %meet merge), we create a list of
      ::  all the changes between the mergebase and ali's commit and
      ::  store it in ali-diffs, and we put a similar list for bob's
      ::  commit in bob-diffs.  Then we create bof, which is the a set
      ::  of changes in both ali and bob's commits.  If this has any
      ::  members, we have conflicts, which is an error in a %meet
      ::  merge, so we error out.
      ::
      ::  Otherwise, we merge the merge base data with ali's data and
      ::  bob's data, which produces the data for the new commit.
      ::
          ?($meet $mate $meld)
        =/  bob  (need bob)
        ?:  =(r.ali r.bob)
          (pure:m ~)
        ?.  (~(has by hut.ran) r.bob)
          (error:he cas %bad-bob-tako >r.bob< ~)
        ?:  (~(has in (reachable-takos:sutil r.bob)) r.ali)
          (pure:m ~)
        ?:  (~(has in (reachable-takos:sutil r.ali)) r.bob)
          $(gem %fine)
        =+  r=(find-merge-points:he ali bob)
        ?~  r
          (error:he cas %merge-no-merge-base ~)
        ?.  ?=({* ~ ~} r)
          =+  (lent ~(tap in `(set yaki)`r))
          (error:he cas %merge-criss-cross >[-]< ~)
        =/  bas  n.r
        ?:  ?=(?($mate $meld) gem)
          ;<  ali-diffs=cane              bind:m  (diff-bas ali bob bas)
          ;<  bob-diffs=cane              bind:m  (diff-bas bob ali bas)
          ;<  bof=(map path (unit cage))  bind:m
            (merge-conflicts can.ali-diffs can.bob-diffs)
          ;<    $:  conflicts=(set path)
                    bop=(map path cage)
                    new=yaki
                    erg=(map path ?)
                    e=_this-cor
                ==
              bind:m
            (build gem ali bob bas ali-diffs bob-diffs bof)
          (pure:m `[conflicts bop new erg e])
        =/  ali-diffs=cane  (calc-diffs:he ali bas)
        =/  bob-diffs=cane  (calc-diffs:he bob bas)
        =/  bof=(map path *)
          %-  %~  int  by
              %-  ~(uni by `(map path *)`new.ali-diffs)
              %-  ~(uni by `(map path *)`cal.ali-diffs)
              %-  ~(uni by `(map path *)`can.ali-diffs)
              `(map path *)`old.ali-diffs
          %-  ~(uni by `(map path *)`new.bob-diffs)
          %-  ~(uni by `(map path *)`cal.bob-diffs)
          %-  ~(uni by `(map path *)`can.bob-diffs)
          `(map path *)`old.bob-diffs
        ?^  bof
          (error:he cas %meet-conflict >(~(run by `(map path *)`bof) ,~)< ~)
        =/  old=(map path lobe)
          %+  roll  ~(tap by (~(uni by old.ali-diffs) old.bob-diffs))
          =<  .(old q.bas)
          |=  {{pax/path ~} old/(map path lobe)}
          (~(del by old) pax)
        =/  hat=(map path lobe)
          %-  ~(uni by old)
          %-  ~(uni by new.ali-diffs)
          %-  ~(uni by new.bob-diffs)
          %-  ~(uni by cal.ali-diffs)
          cal.bob-diffs
        =/  del=(map path ?)
          (~(run by (~(uni by old.ali-diffs) old.bob-diffs)) |=(~ %|))
        =/  new  (make-yaki:sutil [r.ali r.bob ~] hat wen)
        %^  pure:m  ~  ~
        :^    ~
            new
          %-  ~(uni by del)
          ^-  (map path ?)
          %.  |=(lobe %&)
          ~(run by (~(uni by new.ali-diffs) cal.ali-diffs))
        this-cor(hut.ran (~(put by hut.ran) r.new new))
      ==
    ::
    ::  Diff a commit against the mergebase.
    ::
    ++  diff-bas
      |=  [yak=yaki yuk=yaki bas=yaki]
      =/  m  (clad ,cane)
      ^-  form:m
      ;<  ~  bind:m
        %+  just-do  /diff-bas
        :*  %f  %build  live=%.n  %pin  wen
            %list
            ^-  (list schematic:ford)
            %+  murn  ~(tap by q.bas)
            |=  {pax/path lob/lobe}
            ^-  (unit schematic:ford)
            =+  a=(~(get by q.yak) pax)
            ?~  a
              ~
            ?:  =(lob u.a)
              ~
            =+  (~(get by q.yuk) pax)
            ?~  -
              ~
            ?:  =(u.a u.-)
              ~
            :-  ~
            =/  disc  ford-disc
            :-  [%$ %path !>(pax)]
            :^  %diff  ford-disc
              (lobe-to-schematic:sutil disc pax lob)
            (lobe-to-schematic:sutil disc pax u.a)
        ==
      ;<  res=made-result:ford  bind:m  expect-ford
      =+  tay=(made-result-to-cages-or-error:util res)
      ?:  ?=(%| -.tay)
        (error:he cas %diff-ali-bad-made leaf+"merge diff ali failed" p.tay)
      =+  can=(cages-to-map:util p.tay)
      ?:  ?=(%| -.can)
        (error:he cas %diff-ali p.can)
      %-  pure:m
      :*  %-  molt
          %+  skip  ~(tap by q.yak)
          |=  {pax/path lob/lobe}
          (~(has by q.bas) pax)
        ::
          %-  molt  ^-  (list (pair path lobe))
          %+  murn  ~(tap by q.bas)
          |=  {pax/path lob/lobe}
          ^-  (unit (pair path lobe))
          =+  a=(~(get by q.yak) pax)
          =+  b=(~(get by q.yuk) pax)
          ?.  ?&  ?=(^ a)
                  !=([~ lob] a)
                  =([~ lob] b)
              ==
            ~
          `[pax +.a]
        ::
          p.can
        ::
          %-  malt  ^-  (list {path ~})
          %+  murn  ~(tap by q.bas)
          |=  {pax/path lob/lobe}
          ?.  =(~ (~(get by q.yak) pax))
            ~
          (some pax ~)
      ==
    ::
    ::  Merge diffs that are on the same file.
    ::
    ++  merge-conflicts
      |=  [conflicts-ali=(map path cage) conflicts-bob=(map path cage)]
      =/  m  (clad ,bof=(map path (unit cage)))
      ^-  form:m
      ;<  ~  bind:m
        %+  just-do  /merge-conflicts
        :*  %f  %build  live=%.n  %list
            ^-  (list schematic:ford)
            %+  turn
              ~(tap by (~(int by conflicts-ali) conflicts-bob))
            |=  {pax/path *}
            ^-  schematic:ford
            =+  cal=(~(got by conflicts-ali) pax)
            =+  cob=(~(got by conflicts-bob) pax)
            =/  her
                =+  (slag (dec (lent pax)) pax)
                ?~(- %$ i.-)
            :-  [%$ %path !>(pax)]
            [%join [p.bob-disc q.bob-disc] her [%$ cal] [%$ cob]]
        ==
      ;<  res=made-result:ford  bind:m  expect-ford
      =+  tay=(made-result-to-cages-or-error:util res)
      ?:  ?=(%| -.tay)
        (error:he cas %merge-bad-made leaf+"merging failed" p.tay)
      =+  can=(cages-to-map:util p.tay)
      ?:  ?=(%| -.can)
        (error:he cas %merge p.can)
      %-  pure:m
      (~(run by p.can) (flit |=({a/mark ^} !?=($null a))))
    ::
    ::  Apply the patches in bof to get the new merged content.
    ::
    ::  Gather all the changes between ali's and bob's commits and the
    ::  mergebase.  This is similar to the %meet of ++merge, except
    ::  where they touch the same file, we use the merged versions.
    ::
    ++  build
      |=  $:  gem=germ
              ali=yaki
              bob=yaki
              bas=yaki
              dal=cane
              dob=cane
              bof=(map path (unit cage))
          ==
      =/  m
        %-  clad
        $:  conflicts=(set path)
            bop=(map path cage)
            new=yaki
            erg=(map path ?)
            e=_this-cor
        ==
      ^-  form:m
      ;<  ~  bind:m
        %+  just-do  /build
        :*  %f  %build  live=%.n  %list
            ^-  (list schematic:ford)
            %+  murn  ~(tap by bof)
            |=  {pax/path cay/(unit cage)}
            ^-  (unit schematic:ford)
            ?~  cay
              ~
            :-  ~
            :-  [%$ %path !>(pax)]
            =+  (~(get by q.bas) pax)
            ?~  -
              ~|  %mate-strange-diff-no-base
              !!
            :*  %pact
                [p.bob-disc q.bob-disc]
                (lobe-to-schematic:sutil ford-disc pax u.-)
                [%$ u.cay]
            ==
        ==
      ;<  res=made-result:ford  bind:m  expect-ford
      =+  tay=(made-result-to-cages-or-error:util res)
      ?:  ?=(%| -.tay)
        (error:he cas %build-bad-made leaf+"delta building failed" p.tay)
      =/  bop  (cages-to-map:util p.tay)
      ?:  ?=(%| -.bop)
        (error:he cas %built p.bop)
      =/  both-patched  p.bop
      =/  con=(map path *)                            ::  2-change conflict
        %-  molt
        %+  skim  ~(tap by bof)
        |=({pax/path cay/(unit cage)} ?=(~ cay))
      =/  cab=(map path lobe)                         ::  conflict base
        %-  ~(urn by con)
        |=  {pax/path *}
        (~(got by q.bas) pax)
      =.  con                                         ::  change+del conflict
        %-  ~(uni by con)
        %-  malt  ^-  (list {path *})
        %+  skim  ~(tap by old.dal)
        |=  {pax/path ~}
        ?:  (~(has by new.dob) pax)
          ~|  %strange-add-and-del
          !!
        (~(has by can.dob) pax)
      =.  con                                         ::  change+del conflict
        %-  ~(uni by con)
        %-  malt  ^-  (list {path *})
        %+  skim  ~(tap by old.dob)
        |=  {pax/path ~}
        ?:  (~(has by new.dal) pax)
          ~|  %strange-del-and-add
          !!
        (~(has by can.dal) pax)
      =.  con                                         ::  add+add conflict
        %-  ~(uni by con)
        %-  malt  ^-  (list {path *})
        %+  skip  ~(tap by (~(int by new.dal) new.dob))
        |=  {pax/path *}
        =((~(got by new.dal) pax) (~(got by new.dob) pax))
      ?:  &(?=($mate gem) ?=(^ con))
        =+  (turn ~(tap by `(map path *)`con) |=({path *} >[+<-]<))
        (error:he cas %mate-conflict -)
      =/  old=(map path lobe)                         ::  oldies but goodies
        %+  roll  ~(tap by (~(uni by old.dal) old.dob))
        =<  .(old q.bas)
        |=  {{pax/path ~} old/(map path lobe)}
        (~(del by old) pax)
      =/  can=(map path cage)                         ::  content changes
        %-  molt
        ^-  (list (pair path cage))
        %+  murn  ~(tap by bof)
        |=  {pax/path cay/(unit cage)}
        ^-  (unit (pair path cage))
        ?~  cay
          ~
        `[pax u.cay]
      =^  hot  lat.ran                                ::  new content
        ^-  {(map path lobe) (map lobe blob)}
        %+  roll  ~(tap by can)
        =<  .(lat lat.ran)
        |=  {{pax/path cay/cage} hat/(map path lobe) lat/(map lobe blob)}
        =+  ^=  bol
            =+  (~(get by q.bas) pax)
            ?~  -
              ~|  %mate-strange-diff-no-base
              !!
            %^    make-delta-blob:sutil
                (page-to-lobe:sutil [p q.q]:(~(got by both-patched) pax))
              [(lobe-to-mark:sutil u.-) u.-]
            [p q.q]:cay
        [(~(put by hat) pax p.bol) (~(put by lat) p.bol bol)]
      ::  ~&  old=(~(run by old) mug)
      ::  ~&  newdal=(~(run by new.dal) mug)
      ::  ~&  newdob=(~(run by new.dob) mug)
      ::  ~&  caldal=(~(run by cal.dal) mug)
      ::  ~&  caldob=(~(run by cal.dob) mug)
      ::  ~&  hot=(~(run by hot) mug)
      ::  ~&  cas=(~(run by cas) mug)
      =/  hat=(map path lobe)                         ::  all the content
        %-  ~(uni by old)
        %-  ~(uni by new.dal)
        %-  ~(uni by new.dob)
        %-  ~(uni by cal.dal)
        %-  ~(uni by cal.dob)
        %-  ~(uni by hot)
        cab
      =/  del=(map path ?)
          (~(run by (~(uni by old.dal) old.dob)) |=(~ %|))
      =/  new  (make-yaki:sutil [r.ali r.bob ~] hat wen)
      %-  pure:m
      :*  (silt (turn ~(tap by con) head))
          both-patched
          new
        ::
          %-  ~(uni by del)
          ^-  (map path ?)
          %.  |=(lobe %&)
          %~  run  by
          %-  ~(uni by new.dal)
          %-  ~(uni by cal.dal)
          %-  ~(uni by cab)
          hot
        ::
          this-cor(hut.ran (~(put by hut.ran) r.new new))
      ==
    ::
    ::  Convert new commit into actual data (i.e. blobs rather than
    ::  lobes).  Apply the new commit to our state
    ::
    ++  checkout
      |=  [gem=germ cas=case bob=(unit yaki) new=yaki bop=(map path cage)]
      =/  m  (clad ,_this-cor)
      ^-  form:m
      ;<  ~  bind:m
        =/  val=beak
            ?:  ?=($init gem)
              [p.ali-disc q.ali-disc cas]
            [p.bob-disc q.bob-disc da+wen]
        %+  just-do  /checkout
        :*  %f  %build  live=%.n  %pin  wen  %list
            ^-  (list schematic:ford)
            %+  murn  ~(tap by q.new)
            |=  {pax/path lob/lobe}
            ^-  (unit schematic:ford)
            ?:  (~(has by bop) pax)
              ~
            :+  ~
              [%$ %path !>(pax)]
            (merge-lobe-to-schematic:he (fall bob *yaki) ford-disc pax lob)
        ==
      ;<  res=made-result:ford  bind:m  expect-ford
      =+  tay=(made-result-to-cages-or-error:util res)
      ?:  ?=(%| -.tay)
        (error:he cas %checkout-bad-made leaf+"merge checkout failed" p.tay)
      =+  can=(cages-to-map:util p.tay)
      ?:  ?=(%| -.can)
        (error:he cas %checkout p.can)
      =.  let.dom  +(let.dom)
      =.  hit.dom  (~(put by hit.dom) let.dom r.new)
      =.  ank.dom
        %-  map-to-ankh:sutil
        %-  ~(run by (~(uni by bop) p.can))
        |=(cage [(page-to-lobe:sutil p q.q) +<])
      (pure:m this-cor)
    ::
    ::  Cast all the content that we're going to tell unix about to
    ::  %mime, then tell unix.
    ::
    ++  ergo
      |=  [gem=germ cas=case mon=(map term beam) erg=(map path ?) new=yaki]
      =/  m  (clad ,mim=(map path mime))
      ^-  form:m
      =+  must=(must-ergo:util our q.bob-disc mon (turn ~(tap by erg) head))
      ?:  =(~ must)
        (pure:m mim.dom)
      =/  sum=(set path)
        =+  (turn ~(tap by must) (corl tail tail))
        %+  roll  -
        |=  {pak/(set path) acc/(set path)}
        (~(uni in acc) pak)
      =/  val=beak
        ?:  ?=($init gem)
          [p.ali-disc q.ali-disc cas]
        [p.bob-disc q.bob-disc da+wen]
      ;<  ~  bind:m
        %+  just-do  /ergo
        :*  %f  %build  live=%.n  %pin  wen  %list
            ^-  (list schematic:ford)
            %+  turn  ~(tap in sum)
            |=  a/path
            ^-  schematic:ford
            :-  [%$ %path !>(a)]
            =+  b=(~(got by erg) a)
            ?.  b
              [%$ %null !>(~)]
            =/  disc  ford-disc  ::  [p q]:val
            :^  %cast  ford-disc  %mime
            (lobe-to-schematic:sutil disc a (~(got by q.new) a))
        ==
      ;<  res=made-result:ford  bind:m  expect-ford
      =+  tay=(made-result-to-cages-or-error:util res)
      ?:  ?=(%| -.tay)
        (error:he cas %ergo-bad-made leaf+"merge ergo failed" p.tay)
      =+  =|  nac=mode
          |-  ^-  tan=$^(mode {p/term q/tang})
          ?~  p.tay  nac
          =*  pax  p.i.p.tay
          ?.  ?=($path p.pax)
            [%ergo >[%expected-path got=p.pax]< ~]
          =*  mim  q.i.p.tay
          =+  mit=?.(?=($mime p.mim) ~ `;;(mime q.q.mim))
          $(p.tay t.p.tay, nac :_(nac [;;(path q.q.pax) mit]))
      ?:  ?=([@ *] tan)  (error:he cas tan)
      =/  can=(map path (unit mime))  (malt tan)
      =/  mim  (apply-changes-to-mim:util mim.dom can)
      ?~  hez
        (error:he cas %ergo-no-hez ~)
      ^-  form:m
      |=  clad-input
      :-  ~  :_  [%done mim]
      %+  turn  ~(tap by must)
      |=  {pot/term len/@ud pak/(set path)}
      :*  u.hez  %give  %ergo  pot
          %+  turn  ~(tap in pak)
          |=  pax/path
          [(slag len pax) (~(got by can) pax)]
      ==
    ::
    ::  A small set of helper functions to assist in merging.
    ::
    ++  he
      |%
      ::
      ::  Cancel the merge gracefully and produce an error.
      ::
      ++  error
        |=  [cas=case err=term tan=(list tank)]
        (clad-fail err >ali-disc< >bob-disc< >cas< tan)
      ::
      ++  calc-diffs
        |=  [hed=yaki bas=yaki]
        ^-  cane
        :*  %-  molt
            %+  skip  ~(tap by q.hed)
            |=  {pax/path lob/lobe}
            (~(has by q.bas) pax)
          ::
            %-  molt
            %+  skip  ~(tap by q.hed)
            |=  {pax/path lob/lobe}
            =+  (~(get by q.bas) pax)
            |(=(~ -) =([~ lob] -))
          ::
            ~
          ::
            %-  malt  ^-  (list {path ~})
            %+  murn  ~(tap by q.bas)
            |=  {pax/path lob/lobe}
            ^-  (unit (pair path ~))
            ?.  =(~ (~(get by q.hed) pax))
              ~
            `[pax ~]
        ==
      ::
      ::  Create a schematic to turn a lobe into a blob.
      ::
      ::  We short-circuit if we already have the content somewhere.
      ::
      ++  merge-lobe-to-schematic
        |=  [bob=yaki disc=disc:ford pax=path lob=lobe]
        ^-  schematic:ford
        =+  lol=(~(get by q.bob) pax)
        |-  ^-  schematic:ford
        ?:  =([~ lob] lol)
          =+  (need (need (read-x:sutil & let.dom pax)))
          ?>  ?=(%& -<)
          [%$ p.-]
        ::  ?:  =([~ lob] lal)
        ::    [%$ +:(need fil.ank:(descend-path:(zu:sutil ank:(need alh)) pax))]
        =+  bol=(~(got by lat.ran) lob)
        ?-  -.bol
            $direct  (page-to-schematic:sutil disc q.bol)
            $delta
          [%pact disc $(lob q.q.bol) (page-to-schematic:sutil disc r.bol)]
        ==
      ::
      ::  Find the most recent common ancestor(s).
      ::
      ++  find-merge-points
        |=  {p/yaki q/yaki}                           ::  maybe need jet
        ^-  (set yaki)
        %-  reduce-merge-points
        =+  r=(reachable-takos:sutil r.p)
        |-  ^-  (set yaki)
        ?:  (~(has in r) r.q)  (~(put in *(set yaki)) q)
        %+  roll  p.q
        |=  {t/tako s/(set yaki)}
        ?:  (~(has in r) t)
          (~(put in s) (tako-to-yaki:sutil t))        ::  found
        (~(uni in s) ^$(q (tako-to-yaki:sutil t)))    ::  traverse
      ::
      ::  Helper for ++find-merge-points.
      ::
      ++  reduce-merge-points
        |=  unk/(set yaki)                            ::  maybe need jet
        =|  gud/(set yaki)
        =+  ^=  zar
            ^-  (map tako (set tako))
            %+  roll  ~(tap in unk)
            |=  {yak/yaki qar/(map tako (set tako))}
            (~(put by qar) r.yak (reachable-takos:sutil r.yak))
        |-
        ^-  (set yaki)
        ?~  unk  gud
        =+  bun=(~(del in `(set yaki)`unk) n.unk)
        ?:  %+  levy  ~(tap by (~(uni in gud) bun))
            |=  yak/yaki
            !(~(has in (~(got by zar) r.yak)) r.n.unk)
          $(gud (~(put in gud) n.unk), unk bun)
        $(unk bun)
      --
    --
  --
::
::  An assortment of useful functions, used in +commit, +merge, and +de
::
++  util
  |%
  ::  Takes a list of changed paths and finds those paths that are inside a
  ::  mount point (listed in `mon`).
  ::
  ::  Output is a map of mount points to {length-of-mounted-path set-of-paths}.
  ::
  ++  must-ergo
    |=  [our=ship syd=desk mon=(map term beam) can/(list path)]
    ^-  (map term (pair @ud (set path)))
    %-  malt  ^-  (list (trel term @ud (set path)))
    %+  murn  ~(tap by mon)
    |=  {nam/term bem/beam}
    ^-  (unit (trel term @ud (set path)))
    =-  ?~(- ~ `[nam (lent s.bem) (silt `(list path)`-)])
    %+  skim  can
    |=  pax/path
    &(=(p.bem our) =(q.bem syd) =((flop s.bem) (scag (lent s.bem) pax)))
  ::
  ::  Add or remove entries to the mime cache
  ::
  ++  apply-changes-to-mim
    |=  [mim=(map path mime) changes=(map path (unit mime))]
    ^-  (map path mime)
    =/  changes-l=(list [pax=path change=(unit mime)])
      ~(tap by changes)
    |-  ^-  (map path mime)
    ?~  changes-l
      mim
    ?~  change.i.changes-l
      $(changes-l t.changes-l, mim (~(del by mim) pax.i.changes-l))
    $(changes-l t.changes-l, mim (~(put by mim) [pax u.change]:i.changes-l))
  ::
  ::  Crashes on ford failure
  ::
  ++  ford-fail  |=(tan/tang ~|(%ford-fail (mean tan)))
  ::
  ::  Takes either a result or a stack trace.  If it's a stack trace, we crash;
  ::  else, we produce the result.
  ::
  ++  unwrap-tang
    |*  res/(each * tang)
    ?:(?=(%& -.res) p.res (mean p.res))
  ::
  ::  Parse a gage to a list of pairs of cages, crashing on error.
  ::
  ::  Composition of ++gage-to-cages-or-error and ++unwrap-tang.  Maybe same as
  ::  ++gage-to-success-cages?
  ::
  ++  made-result-to-cages
    |=  result=made-result:ford
    ^-  (list (pair cage cage))
    (unwrap-tang (made-result-to-cages-or-error result))
  ::
  ::  Same as ++gage-to-cages-or-error except crashes on error.  Maybe same as
  ::  ++gage-to-cages?
  ::
  ++  made-result-to-success-cages
    |=  result=made-result:ford
    ^-  (list (pair cage cage))
    ?.  ?=([%complete %success %list *] result)
      (ford-fail >%strange-ford-result< ~)
    ::  process each row in the list, filtering out errors
    ::
    %+  murn  results.build-result.result
    |=  row=build-result:ford
    ^-  (unit [cage cage])
    ::
    ?:  ?=([%error *] row)
      ~&  [%clay-whole-build-failed message.row]
      ~
    ?:  ?=([%success [%error *] *] row)
      ~&  [%clay-first-failure message.head.row]
      ~
    ?:  ?=([%success [%success *] [%error *]] row)
      ~&  %clay-second-failure
      %-  (slog message.tail.row)
      ~
    ?.  ?=([%success [%success *] [%success *]] row)
      ~
    `[(result-to-cage:ford head.row) (result-to-cage:ford tail.row)]
  ::
  ::  Expects a single-level gage (i.e. a list of pairs of cages).  If the
  ::  result is of a different form, or if some of the computations in the gage
  ::  failed, we produce a stack trace.  Otherwise, we produce the list of pairs
  ::  of cages.
  ::
  ++  made-result-to-cages-or-error
    |=  result=made-result:ford
    ^-  (each (list (pair cage cage)) tang)
    ::
    ?:  ?=([%incomplete *] result)
      (mule |.(`~`(ford-fail tang.result)))
    ?.  ?=([%complete %success %list *] result)
      (mule |.(`~`(ford-fail >%strange-ford-result -.build-result.result< ~)))
    =/  results=(list build-result:ford)
      results.build-result.result
    =<  ?+(. [%& .] {@ *} .)
    |-
    ^-  ?((list [cage cage]) (each ~ tang))
    ?~  results  ~
    ::
    ?.  ?=([%success ^ *] i.results)
      (mule |.(`~`(ford-fail >%strange-ford-result< ~)))
    ?:  ?=([%error *] head.i.results)
      (mule |.(`~`(ford-fail message.head.i.results)))
    ?:  ?=([%error *] tail.i.results)
      (mule |.(`~`(ford-fail message.tail.i.results)))
    ::
    =+  $(results t.results)
    ?:  ?=([@ *] -)  -
    :_  -
    [(result-to-cage:ford head.i.results) (result-to-cage:ford tail.i.results)]
  ::
  ::  Assumes the list of pairs of cages is actually a listified map of paths
  ::  to cages, and converts it to (map path cage) or a stack trace on error.
  ::
  ++  cages-to-map
    |=  tay/(list (pair cage cage))
    =|  can/(map path cage)
    |-  ^-  (each (map path cage) tang)
    ?~  tay   [%& can]
    =*  pax  p.i.tay
    ?.  ?=($path p.pax)
      (mule |.(`~`~|([%expected-path got=p.pax] !!)))
    $(tay t.tay, can (~(put by can) ;;(path q.q.pax) q.i.tay))
  ::
  ::  Useful functions which operate on a dome and a rang.
  ::
  ::  `original-dome` is the dome which we had when the transaction
  ::  started.  This is used as a lobe-to-blob cache in
  ::  +lobe-to-schematic so we don't have to recalculate the blobs for
  ::  files which haven't changed.
  ::
  ++  state
    |=  [original-dome=dome dom=dome ran=rang]
    |%
    ::  These convert between aeon (version number), tako (commit hash), yaki
    ::  (commit data structure), lobe (content hash), and blob (content).
    ++  aeon-to-tako  ~(got by hit.dom)
    ++  aeon-to-yaki  (cork aeon-to-tako tako-to-yaki)
    ++  lobe-to-blob  ~(got by lat.ran)
    ++  tako-to-yaki  ~(got by hut.ran)
    ++  lobe-to-mark
      |=  a/lobe
      =>  (lobe-to-blob a)
      ?-  -
        $delta      p.q
        $direct     p.q
      ==
    ::
    ::  Create a schematic out of a page (which is a [mark noun]).
    ::
    ++  page-to-schematic
      |=  [disc=disc:ford a=page]
      ^-  schematic:ford
      ?.  ?=($hoon p.a)  [%volt disc a]
      ::  %hoon bootstrapping
      [%$ p.a [%atom %t ~] q.a]
    ::
    ::  Create a schematic out of a lobe (content hash).
    ::
    ++  lobe-to-schematic  (cury lobe-to-schematic-p &)
    ++  lobe-to-schematic-p
      =.  dom  original-dome
      |=  [local=? disc=disc:ford pax=path lob=lobe]
      ^-  schematic:ford
      ::
      =+  ^-  hat/(map path lobe)
          ?:  =(let.dom 0)
            ~
          q:(aeon-to-yaki let.dom)
      =+  lol=`(unit lobe)`?.(local `0vsen.tinel (~(get by hat) pax))
      |-  ^-  schematic:ford
      ?:  =([~ lob] lol)
        =+  (need (need (read-x & let.dom pax)))
        ?>  ?=(%& -<)
        [%$ p.-]
      =+  bol=(~(got by lat.ran) lob)
      ?-  -.bol
        $direct  (page-to-schematic disc q.bol)
        $delta   ~|  delta+q.q.bol
                 [%pact disc $(lob q.q.bol) (page-to-schematic disc r.bol)]
      ==
    ::
    ::  Hash a page to get a lobe.
    ::
    ++  page-to-lobe  |=(page (shax (jam +<)))
    ::
    ::  Make a direct blob out of a page.
    ::
    ++  make-direct-blob
      |=  p/page
      ^-  blob
      [%direct (page-to-lobe p) p]
    ::
    ::  Make a delta blob out of a lobe, mark, lobe of parent, and page of diff.
    ::
    ++  make-delta-blob
      |=  {p/lobe q/{p/mark q/lobe} r/page}
      ^-  blob
      [%delta p q r]
    ::
    ::  Make a commit out of a list of parents, content, and date.
    ::
    ++  make-yaki
      |=  {p/(list tako) q/(map path lobe) t/@da}
      ^-  yaki
      =+  ^=  has
          %^  cat  7  (sham [%yaki (roll p add) q t])
          (sham [%tako (roll p add) q t])
      [p q has t]
    ::
    ++  case-to-date
      |=  [now=@da =case]
      ^-  @da
      ::  if the case is already a date, use it.
      ::
      ?:  ?=([%da *] case)
        p.case
      ::  translate other cases to dates
      ::
      =/  aey  (case-to-aeon-before now case)
      ?~  aey  `@da`0
      ?:  =(0 u.aey)  `@da`0
      t:(aeon-to-yaki u.aey)
    ::
    ::  Reduce a case to an aeon (version number)
    ::
    ::  We produce null if we can't yet reduce the case for whatever
    ::  resaon (usually either the time or aeon hasn't happened yet or
    ::  the label hasn't been created).
    ::
    ++  case-to-aeon-before
      |=  [lim=@da lok=case]
      ^-  (unit aeon)
      ?-    -.lok
          $da
        ?:  (gth p.lok lim)  ~
        |-  ^-  (unit aeon)
        ?:  =(0 let.dom)  [~ 0]                         ::  avoid underflow
        ?:  %+  gte  p.lok
            =<  t
            ~|  [%letdom let=let.dom hit=hit.dom hut=(~(run by hut.ran) ,~)]
            ~|  [%getdom (~(get by hit.dom) let.dom)]
            %-  aeon-to-yaki
            let.dom
          [~ let.dom]
        $(let.dom (dec let.dom))
      ::
          $tas  (~(get by lab.dom) p.lok)
          $ud   ?:((gth p.lok let.dom) ~ [~ p.lok])
      ==
    ::
    ::  Convert a map of paths to data into an ankh.
    ::
    ++  map-to-ankh
      |=  hat/(map path (pair lobe cage))
      ^-  ankh
      %+  roll  ~(tap by hat)
      |=  {{pat/path lob/lobe zar/cage} ank/ankh}
      ^-  ankh
      ?~  pat
        ank(fil [~ lob zar])
      =+  nak=(~(get by dir.ank) i.pat)
      %=  ank
        dir  %+  ~(put by dir.ank)  i.pat
             $(pat t.pat, ank (fall nak *ankh))
      ==
    ::
    ::  Update the object store with new blobs.
    ::
    ++  add-blobs
      |=  [new-blobs=(map path blob) old-lat=(map lobe blob)]
      ^-  (map lobe blob)
      %-  ~(uni by old-lat)
      %-  malt
      %+  turn
        ~(tap by new-blobs)
      |=  [=path =blob]
      [p.blob blob]
    ::
    ::  Apply a change list, creating the commit and applying it to
    ::  the current state.
    ::
    ++  execute-changes
      |=  [wen=@da lem=suba]
      ^-  (unit [dome rang])
      =/  parent
        ?:  =(0 let.dom)
          ~
        [(aeon-to-tako let.dom)]~
      =/  new-blobs  (apply-changes lem)
      =.  lat.ran  (add-blobs new-blobs lat.ran)
      =/  new-lobes  (~(run by new-blobs) |=(=blob p.blob))
      =/  new-yaki  (make-yaki parent new-lobes wen)
      ::  if no changes and not first commit or merge, abort
      ?.  ?|  =(0 let.dom)
              !=((lent p.new-yaki) 1)
              !=(q.new-yaki q:(aeon-to-yaki let.dom))
          ==
          ~
      =:  let.dom  +(let.dom)
          hit.dom  (~(put by hit.dom) +(let.dom) r.new-yaki)
          hut.ran  (~(put by hut.ran) r.new-yaki new-yaki)
      ==
      `[dom ran]
    ::
    ::  Apply label to current revision
    ::
    ++  execute-label
      |=  lab=@tas
      ?<  (~(has by lab.dom) lab)
      dom(lab (~(put by lab.dom) lab let.dom))
    ::
    ::  Apply a list of changes against the current state and produce
    ::  the new state.
    ::
    ++  apply-changes                                   ::   apply-changes
      |=  [change-files=(list [p=path q=misu])]
      ^-  (map path blob)
      =+  ^=  old-files                                 ::  current state
          ?:  =(let.dom 0)                              ::  initial commit
            ~                                           ::  has nothing
          =<  q
          %-  aeon-to-yaki
          let.dom
      =;  new-files=(map path blob)
          =+  sar=(silt (turn change-files head))       ::  changed paths
          %+  roll  ~(tap by old-files)                 ::  find unchanged
          =<  .(bat new-files)
          |=  [[pax=path gar=lobe] bat=(map path blob)]
          ?:  (~(has in sar) pax)                       ::  has update
            bat
          %+  ~(put by bat)  pax
          ~|  [pax gar (lent ~(tap by lat.ran))]
          (lobe-to-blob gar)                            ::  use original
      %+  roll  change-files
      |=  {{pax/path mys/misu} new-files/(map path blob)}
      ^+  new-files
      ?-    -.mys
          $ins                                          ::  insert if not exist
        ?:  (~(has by new-files) pax)
          ~|([%ins-new-files pax] !!)
        ?:  (~(has by old-files) pax)
          ~|([%ins-old-files pax] !!)
        %+  ~(put by new-files)  pax
        %-  make-direct-blob
        ?:  &(?=($mime -.p.mys) =([%hoon ~] (slag (dec (lent pax)) pax)))
          `page`[%hoon +.+.q.q.p.mys]
        [p q.q]:p.mys
      ::
          $del                                          ::  delete if exists
        ?>  |((~(has by old-files) pax) (~(has by new-files) pax))
        (~(del by new-files) pax)
      ::
          $dif                                          ::  mutate, must exist
        =+  ber=(~(get by new-files) pax)               ::  XX  typed
        =+  her==>((flop pax) ?~(. %$ i))
        ?~  ber
          =+  har=(~(get by old-files) pax)
          ?~  har  !!
          %+  ~(put by new-files)  pax
          (make-delta-blob p.mys [(lobe-to-mark u.har) u.har] [p q.q]:q.mys)
                                                        :: XX check vase !evil
        ::  XX of course that's a problem, p.u.ber isn't in rang since it
        ::     was just created.  We shouldn't be sending multiple
        ::     diffs
        ::  %+  ~(put by bar)  pax
        ::  %^  make-delta-blob  p.mys
        ::    [(lobe-to-mark p.u.ber) p.u.ber]
        ::  [p q.q]:q.mys
        ::                                              :: XX check vase !evil
        ~|([%two-diffs-for-same-file pax] !!)
      ==
    ::
    ::  Traverse parentage and find all ancestor hashes
    ::
    ++  reachable-takos                                 ::  reachable
      |=  p/tako
      ^-  (set tako)
      =+  y=(tako-to-yaki p)
      %+  roll  p.y
      =<  .(s (~(put in *(set tako)) p))
      |=  {q/tako s/(set tako)}
      ?:  (~(has in s) q)                               ::  already done
        s                                               ::  hence skip
      (~(uni in s) ^$(p q))                             ::  otherwise traverse
    ::
    ::  Get the data at a node.
    ::
    ::  If it's in our ankh (current state cache), we can just produce
    ::  the result.  Otherwise, we've got to look up the node at the
    ::  aeon to get the content hash, use that to find the blob, and use
    ::  the blob to get the data.  We also special-case the hoon mark
    ::  for bootstrapping purposes.
    ::
    ++  read-x
      |=  [local=? yon=aeon pax=path]
      ^-  (unit (unit (each cage lobe)))
      ?:  =(0 yon)
        [~ ~]
      =+  tak=(~(get by hit.dom) yon)
      ?~  tak
        ~
      ?:  &(local =(yon let.dom))
        :-  ~
        %+  bind
          fil.ank:(descend-path:(zu ank.dom) pax)
        |=(a/{p/lobe q/cage} [%& q.a])
      =+  yak=(tako-to-yaki u.tak)
      =+  lob=(~(get by q.yak) pax)
      ?~  lob
        [~ ~]
      =+  mar=(lobe-to-mark u.lob)
      ?.  ?=($hoon mar)
        [~ ~ %| u.lob]
      :^  ~  ~  %&
      :+  mar  [%atom %t ~]
      |-  ^-  @t                      ::  (urge cord) would be faster
      =+  bol=(lobe-to-blob u.lob)
      ?:  ?=($direct -.bol)
        ;;(@t q.q.bol)
      ?>  ?=($delta -.bol)
      =+  txt=$(u.lob q.q.bol)
      ?>  ?=($txt-diff p.r.bol)
      =+  dif=;;((urge cord) q.r.bol)
      =,  format
      =+  pac=(of-wain (lurk:differ (to-wain (cat 3 txt '\0a')) dif))
      (end 3 (dec (met 3 pac)) pac)
    ::
    ::  Traverse an ankh.
    ::
    ++  zu                                              ::  filesystem
      |=  ank/ankh                                      ::  filesystem state
      =|  ram/path                                      ::  reverse path into
      |%
      ++  descend                                       ::  descend
        |=  lol/@ta
        ^+  +>
        =+  you=(~(get by dir.ank) lol)
        +>.$(ram [lol ram], ank ?~(you [~ ~] u.you))
      ::
      ++  descend-path                                  ::  descend recursively
        |=  way/path
        ^+  +>
        ?~(way +> $(way t.way, +> (descend i.way)))
      --
    --
  --
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::  section 4cA, filesystem logic
::
::  This core contains the main logic of clay.  Besides `++ze`, this directly
::  contains the logic for commiting new revisions (local urbits), managing
::  and notifying subscribers (reactivity), and pulling and validating content
::  (remote urbits).
::
::  The state includes:
::
::  --  local urbit `our`
::  --  current time `now`
::  --  current duct `hen`
::  --  scry handler `ski`
::  --  all vane state `++raft` (rarely used, except for the object store)
::  --  target urbit `her`
::  --  target desk `syd`
::
::  For local desks, `our` == `her` is one of the urbits on our pier.  For
::  foreign desks, `her` is the urbit the desk is on and `our` is the local
::  urbit that's managing the relationship with the foreign urbit.  Don't mix
::  up those two, or there will be wailing and gnashing of teeth.
::
::  While setting up `++de`, we check if `our` == `her`. If so, we get
::  the desk information from `dos.rom`.  Otherwise, we get the rung from
::  `hoy` and get the desk information from `rus` in there.  In either case,
::  we normalize the desk information to a `++rede`, which is all the
::  desk-specific data that we utilize in `++de`.  Because it's effectively
::  a part of the `++de` state, let's look at what we've got:
::
::  --  `lim` is the most recent date we're confident we have all the
::      information for.  For local desks, this is always `now`.  For foreign
::      desks, this is the last time we got a full update from the foreign
::      urbit.
::  --  `ref` is a possible request manager.  For local desks, this is null.
::      For foreign desks, this keeps track of all pending foreign requests
::      plus a cache of the responses to previous requests.
::  --  `qyx` is the set of subscriptions, with listening ducts. These
::      subscriptions exist only until they've been filled.
::  --  `dom` is the actual state of the filetree.  Since this is used almost
::      exclusively in `++ze`, we describe it there.
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
++  de                                                  ::  per desk
  |=  [our=ship now=@da ski=sley hen=duct raft]
  |=  [her=ship syd=desk]
  ::  XX ruf=raft crashes in the compiler
  ::
  =*  ruf  |4.+6.^$
  ::
  =+  ^-  [hun=(unit duct) rede]
      ?.  =(our her)
        ::  no duct, foreign +rede or default
        ::
        :-  ~
        =/  rus  rus:(fall (~(get by hoy.ruf) her) *rung)
        %+  fall  (~(get by rus) syd)
        [lim=~2000.1.1 ref=`*rind qyx=~ dom=*dome per=~ pew=~]
      ::  administrative duct, domestic +rede
      ::
      :-  `hun.rom.ruf
      =/  jod  (fall (~(get by dos.rom.ruf) syd) *dojo)
      [lim=now ref=~ [qyx dom per pew]:jod]
  ::
  =*  red=rede  ->
  =|  mow/(list move)
  |%
  ++  abet                                              ::  resolve
    ^-  [(list move) raft]
    :-  (flop mow)
    ?.  =(our her)
      ::  save foreign +rede
      ::
      =/  run  (fall (~(get by hoy.ruf) her) *rung)
      =?  rit.run  =(0 rit.run)
        (fall (rift-scry her) *rift)
      =/  rug  (~(put by rus.run) syd red)
      ruf(hoy (~(put by hoy.ruf) her run(rus rug)))
    ::  save domestic +room
    ::
    %=  ruf
      hun.rom  (need hun)
      dos.rom  (~(put by dos.rom.ruf) syd [qyx dom per pew]:red)
    ==
  ::
  ::  +rift-scry: for a +rift
  ::
  ++  rift-scry
    |=  who=ship
    ^-  (unit rift)
    =;  rit
      ?~(rit ~ u.rit)
    ;;  (unit (unit rift))
    %-  (sloy-light ski)
    =/  pur=spur
      /(scot %p who)
    [[151 %noun] %j our %rift da+now pur]
  ::
  ::  Handle `%sing` requests
  ::
  ++  aver
    |=  {for/(unit ship) mun/mood}
    ^-  (unit (unit (each cage lobe)))
    =+  ezy=?~(ref ~ (~(get by haw.u.ref) mun))
    ?^  ezy
      `(bind u.ezy |=(a/cage [%& a]))
    =+  nao=(case-to-aeon q.mun)
    ::  ~&  [%aver-mun nao [%from syd lim q.mun]]
    ?~(nao ~ (read-at-aeon:ze for u.nao mun))
  ::
  ::  Queue a move.
  ::
  ++  emit
    |=  mof/move
    %_(+> mow [mof mow])
  ::
  ::  Queue a list of moves
  ::
  ++  emil
    |=  mof/(list move)
    %_(+> mow (weld (flop mof) mow))
  ::
  ::  Produce either null or a result along a subscription.
  ::
  ::  Producing null means subscription has been completed or cancelled.
  ::
  ++  balk
    |=  {hen/duct cay/(unit (each cage lobe)) mun/mood}
    ^+  +>
    ?~  cay  (blub hen)
    (blab hen mun u.cay)
  ::
  ::  Set timer.
  ::
  ++  bait
    |=  {hen/duct tym/@da}
    (emit hen %pass /tyme %b %wait tym)
  ::
  ::  Cancel timer.
  ::
  ++  best
    |=  {hen/duct tym/@da}
    (emit hen %pass /tyme %b %rest tym)
  ::
  ::  Give subscription result.
  ::
  ::  Result can be either a direct result (cage) or a lobe of a result.  In
  ::  the latter case we fetch the data at the lobe and produce that.
  ::
  ++  blab
    |=  {hen/duct mun/mood dat/(each cage lobe)}
    ^+  +>
    ?:  ?=(%& -.dat)
      (emit hen %slip %b %drip !>([%writ ~ [p.mun q.mun syd] r.mun p.dat]))
    %-  emit
    :*  hen  %pass  [%blab p.mun (scot q.mun) syd r.mun]
        %f  %build  live=%.n  %pin
        (case-to-date q.mun)
        (lobe-to-schematic [her syd] r.mun p.dat)
    ==
  ::
  ++  case-to-date  (cury case-to-date:util lim)
  ++  case-to-aeon  (cury case-to-aeon-before:util lim)
  ++  lobe-to-schematic  (cury lobe-to-schematic-p:util ?=(~ ref))
  ::
  ++  blas
    |=  {hen/duct das/(set mood)}
    ^+  +>
    ?>  ?=(^ das)
    ::  translate the case to a date
    ::
    =/  cas  [%da (case-to-date q.n.das)]
    =-  (emit hen %slip %b %drip !>([%wris cas -]))
    (~(run in `(set mood)`das) |=(m/mood [p.m r.m]))
  ::
  ::  Give next step in a subscription.
  ::
  ++  bleb
    |=  {hen/duct ins/@ud hip/(unit (pair aeon aeon))}
    ^+  +>
    %^  blab  hen  [%w [%ud ins] ~]
    :-  %&
    ?~  hip
      [%null [%atom %n ~] ~]
    [%nako !>((make-nako:ze u.hip))]
  ::
  ::  Tell subscriber that subscription is done.
  ::
  ++  blub
    |=  hen/duct
    (emit hen %slip %b %drip !>([%writ ~]))
  ::
  ::  Lifts a function so that a single result can be fanned out over a set of
  ::  subscriber ducts.
  ::
  ::  Thus, `((duct-lift func) subs arg)` runs `(func sub arg)` for each `sub`
  ::  in `subs`.
  ::
  ++  duct-lift
    |*  send/_|=({duct *} ..duct-lift)
    |=  {a/(set duct) arg/_+<+.send}  ^+  ..duct-lift
    =+  all=~(tap by a)
    |-  ^+  ..duct-lift
    ?~  all  ..duct-lift
    =.  +>.send  ..duct-lift
    $(all t.all, duct-lift (send i.all arg))
  ::
  ++  blub-all  (duct-lift |=({a/duct ~} (blub a)))    ::  lifted ++blub
  ++  blab-all  (duct-lift blab)                        ::  lifted ++blab
  ++  blas-all  (duct-lift blas)                        ::  lifted ++blas
  ++  balk-all  (duct-lift balk)                        ::  lifted ++balk
  ++  bleb-all  (duct-lift bleb)                        ::  lifted ++bleb
  ::
  ::  Transfer a request to another ship's clay.
  ::
  ++  send-over-ames
    |=  {a/duct b/path c/ship d/{p/@ud q/riff}}
    (emit a %pass b %a %want c [%c %question p.q.d (scot %ud p.d) ~] q.d)
  ::
  ::  Printable form of a wove; useful for debugging
  ::
  ++  print-wove
    |=  =wove
    :-  p.wove
    ?-  -.q.wove
      %sing  [%sing p.q.wove]
      %next  [%next [p q]:q.wove]
      %mult  [%mult [p q]:q.wove]
      %many  [%many [p q]:q.wove]
    ==
  ::
  ::  Printable form of a cult; useful for debugging
  ::
  ++  print-cult
    |=  =cult
    %+  turn  ~(tap by cult)
    |=  [=wove ducts=(set duct)]
    [ducts (print-wove wove)]
  ::
  ::  Create a request that cannot be filled immediately.
  ::
  ::  If it's a local request, we just put in in `qyx`, setting a timer if it's
  ::  waiting for a particular time.  If it's a foreign request, we add it to
  ::  our request manager (ref, which is a ++rind) and make the request to the
  ::  foreign ship.
  ::
  ++  duce                                              ::  produce request
    |=  wov=wove
    ^+  +>
    =.  wov  (dedupe wov)
    =.  qyx  (~(put ju qyx) wov hen)
    ?~  ref
      (mabe q.wov |=(@da (bait hen +<)))
    |-  ^+  +>+.$
    =+  rav=(reve q.wov)
    =+  ^=  vaw  ^-  rave
      ?.  ?=({$sing $v *} rav)  rav
      [%many %| [%ud let.dom] `case`q.p.rav r.p.rav]
    =+  inx=nix.u.ref
    =.  +>+.$
      =<  ?>(?=(^ ref) .)
      (send-over-ames hen [(scot %ud inx) ~] her inx syd ~ vaw)
    %=  +>+.$
      nix.u.ref  +(nix.u.ref)
      bom.u.ref  (~(put by bom.u.ref) inx [hen vaw])
      fod.u.ref  (~(put by fod.u.ref) hen inx)
    ==
  ::
  ::  If a similar request exists, switch to the existing request.
  ::
  ::  "Similar" requests are those %next and %many requests which are the same
  ::  up to starting case, but we're already after the starting case.  This
  ::  stacks later requests for something onto the same request so that they
  ::  all get filled at once.
  ::
  ++  dedupe                                            ::  find existing alias
    |=  wov/wove
    ^-  wove
    =;  won/(unit wove)  (fall won wov)
    =*  rov  q.wov
    ?-    -.rov
        $sing  ~
        $next
      =+  aey=(case-to-aeon q.p.rov)
      ?~  aey  ~
      %-  ~(rep in ~(key by qyx))
      |=  {haw/wove res/(unit wove)}
      ?^  res  res
      ?.  =(p.wov p.haw)  ~
      =*  hav  q.haw
      =-  ?:(- `haw ~)
      ?&  ?=($next -.hav)
          =(p.hav p.rov(q q.p.hav))
        ::
          ::  only a match if this request is before
          ::  or at our starting case.
          =+  hay=(case-to-aeon q.p.hav)
          ?~(hay | (lte u.hay u.aey))
      ==
    ::
        $mult
      =+  aey=(case-to-aeon p.p.rov)
      ?~  aey  ~
      %-  ~(rep in ~(key by qyx))
      |=  {haw/wove res/(unit wove)}
      ?^  res  res
      ?.  =(p.wov p.haw)  ~
      =*  hav  q.haw
      =-  ?:(- `haw ~)
      ?&  ?=($mult -.hav)
          =(p.hav p.rov(p p.p.hav))
        ::
          ::  only a match if this request is before
          ::  or at our starting case, and it has been
          ::  tested at least that far.
          =+  hay=(case-to-aeon p.p.hav)
          ?&  ?=(^ hay)
              (lte u.hay u.aey)
              ?=(^ q.hav)
              (gte u.q.hav u.aey)
          ==
      ==
    ::
        $many
      =+  aey=(case-to-aeon p.q.rov)
      ?~  aey  ~
      %-  ~(rep in ~(key by qyx))
      |=  {haw/wove res/(unit wove)}
      ?^  res  res
      ?.  =(p.wov p.haw)  ~
      =*  hav  q.haw
      =-  ?:(- `haw ~)
      ?&  ?=($many -.hav)
          =(hav rov(p.q p.q.hav))
        ::
          ::  only a match if this request is before
          ::  or at our starting case.
          =+  hay=(case-to-aeon p.q.hav)
          ?~(hay | (lte u.hay u.aey))
      ==
    ==
  ::
  ::  Initializes a new mount point.
  ::
  ++  mont
    |=  {pot/term bem/beam}
    ^+  +>
    =+  pax=s.bem
    =+  cas=(need (case-to-aeon r.bem))
    =+  can=(turn ~(tap by q:(aeon-to-yaki:ze cas)) head)
    =+  mus=(skim can |=(paf/path =(pax (scag (lent pax) paf))))
    ?~  mus
      +>.$
    %-  emit
    ^-  move
    :*  hen  %pass  [%ergoing (scot %p her) syd ~]  %f
        %build  live=%.n  %list
        ^-  (list schematic:ford)
        %+  turn  `(list path)`mus
        |=  a/path
        :-  [%$ %path !>(a)]
        :^  %cast  [our %home]  %mime
        =+  (need (need (read-x:ze cas a)))
        ?:  ?=(%& -<)
          [%$ p.-]
        (lobe-to-schematic [her syd] a p.-)
    ==
  ::
  ::  Set permissions for a node.
  ::
  ++  perm
    |=  {pax/path rit/rite}
    ^+  +>
    =/  mis/(set @ta)
      %+  roll
        =-  ~(tap in -)
        ?-  -.rit
          $r    who:(fall red.rit *rule)
          $w    who:(fall wit.rit *rule)
          $rw   (~(uni in who:(fall red.rit *rule)) who:(fall wit.rit *rule))
        ==
      |=  {w/whom s/(set @ta)}
      ?:  |(?=(%& -.w) (~(has by cez) p.w))  s
      (~(put in s) p.w)
    ?^  mis
      =-  (emit hen %give %mack `[%leaf "No such group(s): {-}"]~)
      %+  roll  ~(tap in `(set @ta)`mis)
      |=  {g/@ta t/tape}
      ?~  t  (trip g)
      :(weld t ", " (trip g))
    =<  (emit hen %give %mack ~)
    ?-  -.rit
      $r    wake(per (put-perm per pax red.rit))
      $w    wake(pew (put-perm pew pax wit.rit))
      $rw   wake(per (put-perm per pax red.rit), pew (put-perm pew pax wit.rit))
    ==
  ::
  ++  put-perm
    |=  {pes/regs pax/path new/(unit rule)}
    ?~  new  (~(del by pes) pax)
    (~(put by pes) pax u.new)
  ::
  ::  Remove a group from all rules.
  ::
  ++  forget-crew
    |=  nom/@ta
    %=  +>
      per  (forget-crew-in nom per)
      pew  (forget-crew-in nom pew)
    ==
  ::
  ++  forget-crew-in
    |=  {nom/@ta pes/regs}
    %-  ~(run by pes)
    |=  r/rule
    r(who (~(del in who.r) |+nom))
  ::
  ::  Cancel a request.
  ::
  ::  For local requests, we just remove it from `qyx`.  For foreign requests,
  ::  we remove it from `ref` and tell the foreign ship to cancel as well.
  ::
  ++  cancel-request                                    ::  release request
    ^+  .
    =^  wos/(list wove)  qyx
      :_  (~(run by qyx) |=(a/(set duct) (~(del in a) hen)))
      %-  ~(rep by qyx)
      |=  {{a/wove b/(set duct)} c/(list wove)}
      ?.((~(has in b) hen) c [a c])
    ?~  ref
      =>  .(ref `(unit rind)`ref)     ::  XX TMI
      ?:  =(~ wos)  +                                   ::  XX handle?
      |-  ^+  +>
      ?~  wos  +>
      $(wos t.wos, +> (mabe q.i.wos |=(@da (best hen +<))))
    ^+  ..cancel-request
    =+  nux=(~(get by fod.u.ref) hen)
    ?~  nux  ..cancel-request
    =:  fod.u.ref  (~(del by fod.u.ref) hen)
        bom.u.ref  (~(del by bom.u.ref) u.nux)
      ==
    (send-over-ames hen [(scot %ud u.nux) ~] her u.nux syd ~)
  ::
  ::  Handles a request.
  ::
  ::  `%sing` requests are handled by ++aver.  `%next` requests are handled by
  ::  running ++aver at the given case, and then subsequent cases until we find
  ::  a case where the two results aren't equivalent.  If it hasn't happened
  ::  yet, we wait.  `%many` requests are handled by producing as much as we can
  ::  and then waiting if the subscription range extends into the future.
  ::
  ++  start-request
    |=  {for/(unit ship) rav/rave}
    ^+  +>
    ?-    -.rav
        $sing
      =+  ver=(aver for p.rav)
      ?~  ver
        (duce for rav)
      ?~  u.ver
        (blub hen)
      (blab hen p.rav u.u.ver)
    ::
    ::  for %mult and %next, get the data at the specified case, then go forward
    ::  in time until we find a change (as long as we have no unknowns).
    ::  if we find no change, store request for later.
    ::  %next is just %mult with one path, so we pretend %next = %mult here.
        ?($next $mult)
      |^
      =+  cas=?:(?=($next -.rav) q.p.rav p.p.rav)
      =+  aey=(case-to-aeon cas)
      ::  if the requested case is in the future, we can't know anything yet.
      ?~  aey  (store ~ ~ ~)
      =+  old=(read-all-at cas)
      =+  yon=+(u.aey)
      |-  ^+  ..start-request
      ::  if we need future revisions to look for change, wait.
      ?:  (gth yon let.dom)
        (store `yon old ~)
      =+  new=(read-all-at [%ud yon])
      ::  if we don't know everything now, store the request for later.
      ?.  &((levy ~(tap by old) know) (levy ~(tap by new) know))
        (store `yon old new)
      ::  if we do know everything now, compare old and new.
      ::  if there are differences, send response. if not, try next aeon.
      =;  res
        ?~  res  $(yon +(yon))
        (respond res)
      %+  roll  ~(tap by old)
      |=  $:  {{car/care pax/path} ole/cach}
              res/(map mood (each cage lobe))
          ==
      =+  neu=(~(got by new) car pax)
      ?<  |(?=(~ ole) ?=(~ neu))
      =-  ?~(- res (~(put by res) u.-))
      ^-  (unit (pair mood (each cage lobe)))
      =+  mod=[car [%ud yon] pax]
      ?~  u.ole
       ?~  u.neu  ~                                     ::  not added
       `[mod u.u.neu]                                   ::  added
      ?~  u.neu
        `[mod [%& %null [%atom %n ~] ~]]                ::  deleted
      ?:  (equivalent-data:ze u.u.neu u.u.ole)  ~       ::  unchanged
      `[mod u.u.neu]                                    ::  changed
      ::
      ++  store                                         ::  check again later
        |=  $:  nex/(unit aeon)
                old/(map (pair care path) cach)
                new/(map (pair care path) cach)
            ==
        ^+  ..start-request
        %+  duce  for
        ^-  rove
        ?:  ?=($mult -.rav)
          [-.rav p.rav nex old new]
        :^  -.rav  p.rav  nex
        =+  ole=~(tap by old)
        ?>  (lte (lent ole) 1)
        ?~  ole  ~
        q:(snag 0 `(list (pair (pair care path) cach))`ole)
      ::
      ++  respond                                       ::  send changes
        |=  res/(map mood (each cage lobe))
        ^+  ..start-request
        ?:  ?=($mult -.rav)  (blas hen ~(key by res))
        ?>  ?=({* ~ ~} res)
        (blab hen n.res)
      ::
      ++  know  |=({(pair care path) c/cach} ?=(^ c))   ::  know about file
      ::
      ++  read-all-at                                   ::  files at case, maybe
        |=  cas/case
        %-  ~(gas by *(map (pair care path) cach))
        =/  req/(set (pair care path))
          ?:  ?=($mult -.rav)  q.p.rav
          [[p.p.rav r.p.rav] ~ ~]
        %+  turn  ~(tap by req)
        |=  {c/care p/path}
        ^-  (pair (pair care path) cach)
        [[c p] (aver for c cas p)]
      --
    ::
        $many
      =+  nab=(case-to-aeon p.q.rav)
      ?~  nab
        ?>  =(~ (case-to-aeon q.q.rav))
        (duce for [- p q ~]:rav)
      =+  huy=(case-to-aeon q.q.rav)
      ?:  &(?=(^ huy) |((lth u.huy u.nab) &(=(0 u.huy) =(0 u.nab))))
        (blub hen)
      =+  top=?~(huy let.dom u.huy)
      =+  ear=(lobes-at-path:ze for top r.q.rav)
      =.  +>.$
        (bleb hen u.nab ?:(p.rav ~ `[u.nab top]))
      ?^  huy
        (blub hen)
      =+  ^=  ptr  ^-  case
          [%ud +(let.dom)]
      (duce for `rove`[%many p.rav [ptr q.q.rav r.q.rav] ear])
    ==
  ::
  ::  Continue committing
  ::
  ++  take-commit
    |=  =sign
    ^+  +>
    =/  m  commit-clad
    ?~  act
      ~|(%no-active-write !!)
    ?.  ?=(%commit -.eval-data.u.act)
      ~|(%active-not-commit !!)
    =^  r=[moves=(list move) =eval-result:eval:m]  commit.eval-data.u.act
      (take:eval:m commit.eval-data.u.act hen /commit/[syd] now ran sign)
    =>  .(+>.$ (emil moves.r))  :: TMI
    ?-  -.eval-result.r
      %next  +>.$
      %fail  (fail-commit err.eval-result.r)
      %done  (done-commit value.eval-result.r)
    ==
  ::
  ::  Don't release effects or apply state changes; print error
  ::
  ++  fail-commit
    |=  err=(pair term tang)
    ^+  +>
    =?  +>.$  ?=(^ q.err)
      %-  emit
      :*  (need hun)  %give  %note
          '!'  %rose  [" " "" ""]
          leaf+"clay commit error"
          leaf+(trip p.err)
          q.err
      ==
    finish-write
  ::
  ::  Release effects and apply state changes
  ::
  ++  done-commit
    |=  [=dome =rang]
    ^+  +>
    =:  dom      dome
        hut.ran  (~(uni by hut.ran) hut.rang)
        lat.ran  (~(uni by lat.ran) lat.rang)
      ==
    =.  +>.$  wake
    finish-write
  ::
  ::  Continue merging
  ::
  ++  take-merge
    |=  =sign
    ^+  +>
    =/  m  merge-clad
    ?~  act
      ~|(%no-active-write !!)
    ?.  ?=(%merge -.eval-data.u.act)
      ~|(%active-not-merge !!)
    =^  r=[moves=(list move) =eval-result:eval:m]  merge.eval-data.u.act
      (take:eval:m merge.eval-data.u.act hen /merge/[syd] now ran sign)
    =>  .(+>.$ (emil moves.r))  :: TMI
    ?-  -.eval-result.r
      %next  +>.$
      %fail  (fail-merge err.eval-result.r)
      %done  (done-merge value.eval-result.r)
    ==
  ::
  ::  Don't release effects or apply state changes; print error
  ::
  ++  fail-merge
    |=  err=(pair term tang)
    ^+  +>
    =.  +>.$
      (emit [hen %give %mere %| err])
    finish-write
  ::
  ::  Release effects and apply state changes
  ::
  ++  done-merge
    |=  [conflicts=(set path) =dome =rang]
    ^+  +>
    =.  +>.$  (emit [hen %give %mere %& conflicts])
    =:  dom      dome
        hut.ran  (~(uni by hut.ran) hut.rang)
        lat.ran  (~(uni by lat.ran) lat.rang)
      ==
    =.  +>.$  wake
    finish-write
  ::
  ::  Start next item in write queue
  ::
  ++  finish-write
    ^+  .
    =.  act  ~
    ?~  cue
      .
    =/  =duct  duct:(need ~(top to cue))
    (emit [duct %pass /queued-request %b %wait now])
  ::
  ::  Send new data to unix.
  ::
  ::  Combine the paths in mim in dok and the result of the ford call in
  ::  ++take-patch to create a list of nodes that need to be sent to unix (in
  ::  an %ergo card) to keep unix up-to-date.  Send this to unix.
  ::
  ++  take-ergo
    |=  res/made-result:ford
    ^+  +>
    ?:  ?=([%incomplete *] res)
      ~&  %bad-take-ergo
      +>.$
      ::  (print-to-dill '!' %rose [" " "" ""] leaf+"clay ergo failed" tang.res)
    ?.  ?=([%complete %success *] res)
      ~&  %bad-take-ergo-2
      +>.$
      ::  =*  message  message.build-result.res
      ::  (print-to-dill '!' %rose [" " "" ""] leaf+"clay ergo failed" message)
    ?~  hez  ~|(%no-sync-duct !!)
    =+  ^-  can/(map path (unit mime))
        %-  malt  ^-  mode
        %+  turn  (made-result-to-cages:util res)
        |=  {pax/cage mim/cage}
        ?.  ?=($path p.pax)
          ~|(%ergo-bad-path-mark !!)
        :-  ;;(path q.q.pax)
        ?.  ?=($mime p.mim)
          ~
        `;;(mime q.q.mim)
    ::  XX  could interfere with running transaction
    =.  mim.dom  (apply-changes-to-mim:util mim.dom can)
    =+  mus=(must-ergo:util our syd mon (turn ~(tap by can) head))
    %-  emil
    %+  turn  ~(tap by mus)
    |=  {pot/term len/@ud pak/(set path)}
    :*  u.hez  %give  %ergo  pot
        %+  turn  ~(tap in pak)
        |=  pax/path
        [(slag len pax) (~(got by can) pax)]
    ==
  ::
  ::  Called when a foreign ship answers one of our requests.
  ::
  ::  After updating ref (our request manager), we handle %x, %w, and %y
  ::  responses.  For %x, we call ++validate-x to validate the type of
  ::  the response.  For %y, we coerce the result to an arch.
  ::
  ::  For %w, we check to see if it's a @ud response (e.g. for
  ::  cw+//~sampel-sipnym/desk/~time-or-label).  If so, it's easy.
  ::  Otherwise, we look up our subscription request, then assert the
  ::  response was a nako.  If this is the first update for a desk, we
  ::  assume everything's well-typed and call ++apply-foreign-update
  ::  directly.  Otherwise, we call ++validate-plops to verify that the
  ::  data we're getting is well typed.
  ::
  ::  Be careful to call ++wake if/when necessary (i.e. when the state
  ::  changes enough that a subscription could be filled).  Every case
  ::  must call it individually.
  ::
  ++  take-foreign-update                              ::  external change
    |=  {inx/@ud rut/(unit rand)}
    ^+  +>
    ?>  ?=(^ ref)
    |-  ^+  +>+.$
    =+  ruv=(~(get by bom.u.ref) inx)
    ?~  ruv  +>+.$
    =>  ?.  |(?=(~ rut) ?=($sing -.q.u.ruv))  .
        %_  .
          bom.u.ref  (~(del by bom.u.ref) inx)
          fod.u.ref  (~(del by fod.u.ref) p.u.ruv)
        ==
    ?~  rut
      =+  rav=`rave`q.u.ruv
      =<  ?>(?=(^ ref) .)
      %_    wake
          lim
        ?.(&(?=($many -.rav) ?=($da -.q.q.rav)) lim `@da`p.q.q.rav)
      ::
          haw.u.ref
        ?.  ?=($sing -.rav)  haw.u.ref
        (~(put by haw.u.ref) p.rav ~)
      ==
    ?-    p.p.u.rut
        $d
      ~|  %totally-temporary-error-please-replace-me
      !!
        $p
      ~|  %requesting-foreign-permissions-is-invalid
      !!
        $t
      ~|  %requesting-foreign-directory-is-vaporware
      !!
        $u
      ~|  %im-thinkin-its-prolly-a-bad-idea-to-request-rang-over-the-network
      !!
    ::
        $v
      ~|  %weird-we-shouldnt-get-a-dome-request-over-the-network
      !!
    ::
        $x
      =<  ?>(?=(^ ref) .)
      (validate-x p.p.u.rut q.p.u.rut q.u.rut r.u.rut)
    ::
        $w
      =.  haw.u.ref
        %+  ~(put by haw.u.ref)
          [p.p.u.rut q.p.u.rut q.u.rut]
        :+  ~
          p.r.u.rut
        ?+  p.r.u.rut  ~|  %strange-w-over-nextwork  !!
          $cass  !>(;;(cass q.r.u.rut))
          $null  [[%atom %n ~] ~]
          $nako  !>(~|([%molding [&1 &2 &3]:q.r.u.rut] ;;(nako q.r.u.rut)))
        ==
      ?.  ?=($nako p.r.u.rut)  [?>(?=(^ ref) .)]:wake
      =+  rav=`rave`q.u.ruv
      ?>  ?=($many -.rav)
      |-  ^+  +>+.^$
      =+  nez=[%w [%ud let.dom] ~]
      =+  nex=(~(get by haw.u.ref) nez)
      ?~  nex  +>+.^$
      ?~  u.nex  +>+.^$  ::  should never happen
      =.  nak.u.ref  `;;(nako q.q.u.u.nex)
      =.  +>+.^$
        ?:  =(0 let.dom)
          =<  ?>(?=(^ ref) .)
          %+  apply-foreign-update
            ?.(?=($da -.q.q.rav) ~ `p.q.q.rav)
          (need nak.u.ref)
        =<  ?>(?=(^ ref) .)
        %^    validate-plops
            [%ud let.dom]
          ?.(?=($da -.q.q.rav) ~ `p.q.q.rav)
        bar:(need nak.u.ref)
      %=  $
        haw.u.ref  (~(del by haw.u.ref) nez)
      ==
    ::
        $y
      =<  ?>(?=(^ ref) .)
      %_    wake
          haw.u.ref
        %+  ~(put by haw.u.ref)
          [p.p.u.rut q.p.u.rut q.u.rut]
        `[p.r.u.rut !>(;;(arch q.r.u.rut))]
      ==
    ::
        $z
      ~|  %its-prolly-not-reasonable-to-request-ankh-over-the-network-sorry
      !!
    ==
  ::
  ::  Check that given data is actually of the mark it claims to be.
  ::
  ::  Result is handled in ++take-foreign-x
  ::
  ++  validate-x
    |=  {car/care cas/case pax/path peg/page}
    ^+  +>
    %-  emit
    :*  hen  %pass
        [%foreign-x (scot %p our) (scot %p her) syd car (scot cas) pax]
        %f  %build  live=%.n  %pin
        now
        (vale-page [her syd] peg)
    ==
  ::
  ::  Create a schematic to validate a page.
  ::
  ::  If the mark is %hoon, we short-circuit the validation for bootstrapping
  ::  purposes.
  ::
  ++  vale-page
    |=  [disc=disc:ford a=page]
    ^-  schematic:ford
    ?.  ?=($hoon p.a)  [%vale [our %home] a]
    ?.  ?=(@t q.a)  [%dude >%weird-hoon< %ride [%zpzp ~] %$ *cage]
    [%$ p.a [%atom %t ~] q.a]
  ::
  ::  Verify the foreign data is of the the mark it claims to be.
  ::
  ::  This completes the receiving of %x foreign data.
  ::
  ++  take-foreign-x
    |=  {car/care cas/case pax/path res/made-result:ford}
    ^+  +>
    ?>  ?=(^ ref)
    ?.  ?=([%complete %success *] res)
      ~|  "validate foreign x failed"
      =+  why=(made-result-as-error:ford res)
      ~>  %mean.|.(%*(. >[%plop-fail %why]< |1.+> why))
      !!
    =*  as-cage  `(result-to-cage:ford build-result.res)
    wake(haw.u.ref (~(put by haw.u.ref) [car cas pax] as-cage))
  ::
  ::  When we get a %w foreign update, store this in our state.
  ::
  ::  We get the commits and blobs from the nako and add them to our object
  ::  store, then we update the map of aeons to commits and the latest aeon.
  ::
  ::  We call ++wake at the end to update anyone whose subscription is fulfilled
  ::  by this state change.
  ::
  ++  apply-foreign-update                              ::  apply subscription
    |=  $:  lem/(unit @da)                              ::  complete up to
            gar/(map aeon tako)                         ::  new ids
            let/aeon                                    ::  next id
            lar/(set yaki)                              ::  new commits
            bar/(set blob)                              ::  new content
        ==
    ^+  +>
    =<  wake
    ::  hit: updated commit-hashes by @ud case
    ::
    =/  hit  (~(uni by hit.dom) gar)
    ::  nut: new commit-hash/commit pairs
    ::
    =/  nut
      (turn ~(tap in lar) |=(=yaki [r.yaki yaki]))
    ::  hut: updated commits by hash
    ::
    =/  hut  (~(gas by hut.ran) nut)
    ::  nat: new blob-hash/blob pairs
    ::
    =/  nat
      (turn ~(tap in bar) |=(=blob [p.blob blob]))
    ::  lat: updated blobs by hash
    ::
    =/  lat  (~(gas by lat.ran) nat)
    ::  traverse updated state and sanity check
    ::
    =+  ~|  :*  %bad-foreign-update
                [gar=gar let=let nut=(turn nut head) nat=(turn nat head)]
                [hitdom=hit.dom letdom=let.dom]
            ==
      ?:  =(0 let)
        ~
      =/  =aeon  1
      |-  ^-  ~
      =/  =tako
        ~|  [%missing-aeon aeon]  (~(got by hit) aeon)
      =/  =yaki
        ~|  [%missing-tako tako]  (~(got by hut) tako)
      =+  %+  turn
            ~(tap by q.yaki)
          |=  [=path =lobe]
          ~|  [%missing-blob path lobe]
          ?>  (~(has by lat) lobe)
          ~
      ?:  =(let aeon)
        ~
      $(aeon +(aeon))
    ::  persist updated state
    ::
    %=  +>.$
      let.dom   (max let let.dom)
      lim       (max (fall lem lim) lim)
      hit.dom   hit
      hut.ran   hut
      lat.ran   lat
    ==
  ::
  ::  Make sure that incoming data is of the correct type.
  ::
  ::  This is a ford call to make sure that incoming data is of the mark it
  ::  claims to be.  The result is handled in ++take-foreign-plops.
  ::
  ++  validate-plops
    |=  {cas/case lem/(unit @da) pop/(set plop)}
    ^+  +>
    =+  lum=(scot %da (fall lem *@da))
    %-  emit
    :*  hen  %pass
        [%foreign-plops (scot %p our) (scot %p her) syd lum ~]
        %f  %build  live=%.n  %pin
        ::  This corresponds to all the changes from [her syd]
        ::  to [our %home].  This should be (case-to-date cas)
        ::  in the context of the foreign desk, but since we're
        ::  getting everything from our own desk now we want to
        ::  use our most recent commit.
        ::
        now
        %list
        ^-  (list schematic:ford)
        %+  turn  ~(tap in pop)
        |=  a/plop
        ?-  -.a
          $direct  [[%$ %blob !>([%direct p.a *page])] (vale-page [her syd] p.q.a q.q.a)]
          $delta
            [[%$ %blob !>([%delta p.a q.a *page])] (vale-page [her syd] p.r.a q.r.a)]
        ==
    ==
  ::
  ::  Verify that foreign plops validated correctly.  If so, apply them to our
  ::  state.
  ::
  ++  take-foreign-plops
    |=  {lem/(unit @da) res/made-result:ford}
    ^+  +>
    ?>  ?=(^ ref)
    ?>  ?=(^ nak.u.ref)
    =+  ^-  lat/(list blob)
        %+  turn
          ~|  "validate foreign plops failed"
          (made-result-to-cages:[^util] res)
        |=  {bob/cage cay/cage}
        ?.  ?=($blob p.bob)
          ~|  %plop-not-blob
          !!
        =+  bol=;;(blob q.q.bob)
        ?-  -.bol
          $delta      [-.bol p.bol q.bol p.cay q.q.cay]
          $direct     [-.bol p.bol p.cay q.q.cay]
        ==
    %^    apply-foreign-update
        lem
      gar.u.nak.u.ref
    :+  let.u.nak.u.ref
      lar.u.nak.u.ref
    (silt lat)
  ::
  ++  mabe                                            ::  maybe fire function
    |=  {rov/rove fun/$-(@da _.)}
    ^+  +>.$
    %+  fall
      %+  bind
        ^-  (unit @da)
        ?-    -.rov
            $sing
          ?.  ?=($da -.q.p.rov)  ~
          `p.q.p.rov
        ::
            $next  ~
        ::
            $mult  ~
        ::
            $many
          %^  hunt  lth
            ?.  ?=($da -.p.q.rov)  ~
            ?.((lth now p.p.q.rov) ~ [~ p.p.q.rov])
          ?.  ?=($da -.q.q.rov)  ~
          (hunt gth [~ now] [~ p.q.q.rov])
        ==
      fun
    +>.$
  ::
  ++  reve
    |=  rov/rove
    ^-  rave
    ?-  -.rov
      $sing  rov
      $next  [- p]:rov
      $mult  [- p]:rov
      $many  [- p q]:rov
    ==
  ::
  ::  Loop through open subscriptions and check if we can fill any of them.
  ::
  ++  wake                                            ::  update subscribers
    ^+  .
    =+  xiq=~(tap by qyx)
    =|  xaq/(list {p/wove q/(set duct)})
    |-  ^+  ..wake
    ?~  xiq
      ..wake(qyx (~(gas by *cult) xaq))
    ?:  =(~ q.i.xiq)  $(xiq t.xiq, xaq xaq)           :: drop forgotten
    =*  for  p.p.i.xiq
    =*  rov  q.p.i.xiq
    ?-    -.rov
        $sing
      =+  cas=?~(ref ~ (~(get by haw.u.ref) `mood`p.rov))
      ?^  cas
        %=    $
            xiq  t.xiq
            ..wake  ?~  u.cas  (blub-all q.i.xiq ~)
                    (blab-all q.i.xiq p.rov %& u.u.cas)
        ==
      =+  nao=(case-to-aeon q.p.rov)
      ?~  nao  $(xiq t.xiq, xaq [i.xiq xaq])
      ::  ~&  %reading-at-aeon
      =+  vid=(read-at-aeon:ze for u.nao p.rov)
      ::  ~&  %red-at-aeon
      ?~  vid
        ::  ?:  =(0 u.nao)
        ::    ~&  [%oh-poor `path`[syd '0' r.p.rov]]
        ::    $(xiq t.xiq)
        ::  ~&  [%oh-well desk=syd mood=p.rov aeon=u.nao]
        $(xiq t.xiq, xaq [i.xiq xaq])
      $(xiq t.xiq, ..wake (balk-all q.i.xiq u.vid p.rov))
    ::
    ::  %next is just %mult with one path, so we pretend %next = %mult here.
        ?($next $mult)
      ::  because %mult requests need to wait on multiple files for each
      ::  revision that needs to be checked for changes, we keep two cache maps.
      ::  {old} is the revision at {(dec yon)}, {new} is the revision at {yon}.
      ::  if we have no {yon} yet, that means it was still unknown last time
      ::  we checked.
      =*  vor  rov
      |^
      =/  rov/rove
        ?:  ?=($mult -.vor)  vor
        =*  mod  p.vor
        :*  %mult
            [q.mod [[p.mod r.mod] ~ ~]]
            q.vor
            [[[p.mod r.mod] r.vor] ~ ~]
            ~
        ==
      ?>  ?=($mult -.rov)
      =*  mol  p.rov
      =*  yon  q.rov
      =*  old  r.rov
      =*  new  s.rov
      ::  we will either respond, or store the maybe updated request.
      =;  res/(each (map mood (each cage lobe)) rove)
          ?:  ?=(%& -.res)
            (respond p.res)
          (store p.res)
      |-  ::  so that we can retry for the next aeon if possible/needed.
      ::  if we don't have an aeon yet, see if we have one now.
      ?~  yon
        =+  aey=(case-to-aeon p.mol)
        ::  if we still don't, wait.
        ?~  aey  |+rov
        ::  if we do, update the request and retry.
        $(rov [-.rov mol `+(u.aey) ~ ~])
      ::  if old isn't complete, try filling in the gaps.
      =?  old  !(complete old)
        (read-unknown mol(p [%ud (dec u.yon)]) old)
      ::  if the next aeon we want to compare is in the future, wait again.
      =+  aey=(case-to-aeon [%ud u.yon])
      ?~  aey  |+rov
      ::  if new isn't complete, try filling in the gaps.
      =?  new  !(complete new)
        (read-unknown mol(p [%ud u.yon]) new)
      ::  if they're still not both complete, wait again.
      ?.  ?&  (complete old)
              (complete new)
          ==
        |+rov
      ::  if there are any changes, send response. if none, move onto next aeon.
      =;  res
        ?^  res  &+res
        $(rov [-.rov mol `+(u.yon) old ~])
      %+  roll  ~(tap by old)
      |=  $:  {{car/care pax/path} ole/cach}
              res/(map mood (each cage lobe))
          ==
      =+  neu=(~(got by new) car pax)
      ?<  |(?=(~ ole) ?=(~ neu))
      =-  ?~(- res (~(put by res) u.-))
      ^-  (unit (pair mood (each cage lobe)))
      =+  mod=[car [%ud u.yon] pax]
      ?~  u.ole
       ?~  u.neu  ~                                     ::  not added
       `[mod u.u.neu]                                   ::  added
      ?~  u.neu
        `[mod [%& %null [%atom %n ~] ~]]                ::  deleted
      ?:  (equivalent-data:ze u.u.neu u.u.ole)  ~       ::  unchanged
      `[mod u.u.neu]                                    ::  changed
      ::
      ++  store                                         ::  check again later
        |=  rov/rove
        ^+  ..wake
        =-  ^^$(xiq t.xiq, xaq [i.xiq(p [for -]) xaq])
        ?>  ?=($mult -.rov)
        ?:  ?=($mult -.vor)  rov
        ?>  ?=({* ~ ~} r.rov)
        =*  one  n.r.rov
        [%next [p.p.one p.p.rov q.p.one] q.rov q.one]
      ::
      ++  respond                                       ::  send changes
        |=  res/(map mood (each cage lobe))
        ^+  ..wake
        ::NOTE  want to use =-, but compiler bug?
        ?:  ?=($mult -.vor)
          ^^$(xiq t.xiq, ..wake (blas-all q.i.xiq ~(key by res)))
        ?>  ?=({* ~ ~} res)
        ^^$(xiq t.xiq, ..wake (blab-all q.i.xiq n.res))
      ::
      ++  complete                                      ::  no unknowns
        |=  hav/(map (pair care path) cach)
        ?&  ?=(^ hav)
            (levy ~(tap by `(map (pair care path) cach)`hav) know)
        ==
      ::
      ++  know  |=({(pair care path) c/cach} ?=(^ c))   ::  know about file
      ::
      ++  read-unknown                                  ::  fill in the blanks
        |=  {mol/mool hav/(map (pair care path) cach)}
        %.  |=  {{c/care p/path} o/cach}
            ?^(o o (aver for c p.mol p))
        =-  ~(urn by -)
        ?^  hav  hav
        %-  ~(gas by *(map (pair care path) cach))
        (turn ~(tap in q.mol) |=({c/care p/path} [[c p] ~]))
      --
    ::
        $many
      =+  mot=`moat`q.rov
      =*  sav  r.rov
      =+  nab=(case-to-aeon p.mot)
      ?~  nab
        $(xiq t.xiq, xaq [i.xiq xaq])
      =+  huy=(case-to-aeon q.mot)
      ?~  huy
        =.  p.mot  [%ud +(let.dom)]
        %=  $
          xiq     t.xiq
          xaq     [i.xiq(q.q.p mot) xaq]
          ..wake  =+  ^=  ear
                      (lobes-at-path:ze for let.dom r.mot)
                  ?:  =(sav ear)  ..wake
                  (bleb-all q.i.xiq let.dom ?:(p.rov ~ `[u.nab let.dom]))
        ==
      %=  $
        xiq     t.xiq
        ..wake  =-  (blub-all:- q.i.xiq ~)
                =+  ^=  ear
                    (lobes-at-path:ze for u.huy r.mot)
                ?:  =(sav ear)  (blub-all q.i.xiq ~)
                (bleb-all q.i.xiq +(u.nab) ?:(p.rov ~ `[u.nab u.huy]))
      ==
    ==
  ++  drop-me
    ^+  .
    ~|  %clay-drop-me-not-implemented
    !!
    ::  ?~  mer
    ::    .
    ::  %-  emit(mer ~)  ^-  move  :*
    ::    hen.u.mer  %give  %mere  %|  %user-interrupt
    ::    >sor.u.mer<  >our<  >cas.u.mer<  >gem.u.mer<  ~
    ::  ==
  ::
  ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  ::
  ::  This core has no additional state, and the distinction exists purely for
  ::  documentation.  The overarching theme is that `++de` directly contains
  ::  logic for metadata about the desk, while `++ze` is composed primarily
  ::  of helper functions for manipulating the desk state (`++dome`) itself.
  ::  Functions include:
  ::
  ::  --  converting between cases, commit hashes, commits, content hashes,
  ::      and content
  ::  --  creating commits and content and adding them to the tree
  ::  --  finding which data needs to be sent over the network to keep the
  ::      other urbit up-to-date
  ::  --  reading from the file tree through different `++care` options
  ::  --  the `++me` core for merging.
  ::
  ::  The dome is composed of the following:
  ::
  ::  --  `ank` is the ankh, which is the file data itself.  An ankh is both
  ::      a possible file and a possible directory.  An ankh has both:
  ::      --  `fil`, a possible file, stored as both a cage and its hash
  ::      --  `dir`, a map of @ta to more ankhs.
  ::  --  `let` is the number of the most recent revision.
  ::  --  `hit` is a map of revision numbers to commit hashes.
  ::  --  `lab` is a map of labels to revision numbers.
  ::
  ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  ::
  ::  The useful utility functions that are common to several cores
  ::
  ++  util  (state:[^util] dom dom ran)
  ::
  ::  Other utility functions
  ::
  ++  ze
    |%
    ::  These convert between aeon (version number), tako (commit hash), yaki
    ::  (commit data structure), lobe (content hash), and blob (content).
    ++  aeon-to-tako  ~(got by hit.dom)
    ++  aeon-to-yaki  (cork aeon-to-tako tako-to-yaki)
    ++  lobe-to-blob  ~(got by lat.ran)
    ++  tako-to-yaki  ~(got by hut.ran)
    ++  page-to-lobe  page-to-lobe:util
    ::
    ::  Checks whether two pieces of data (either cages or lobes) are the same.
    ::
    ++  equivalent-data
      |=  {one/(each cage lobe) two/(each cage lobe)}
      ^-  ?
      ?:  ?=(%& -.one)
        ?:  ?=(%& -.two)
          =([p q.q]:p.one [p q.q]:p.two)
        =(p.two (page-to-lobe [p q.q]:p.one))
      ?:  ?=(%& -.two)
        =(p.one (page-to-lobe [p q.q]:p.two))
      =(p.one p.two)
    ::
    ::  Gets a map of the data at the given path and all children of it.
    ::
    ++  lobes-at-path
      |=  {for/(unit ship) yon/aeon pax/path}
      ^-  (map path lobe)
      ?:  =(0 yon)  ~
      ::  we use %z for the check because it looks at all child paths.
      ?:  |(?=(~ for) (may-read u.for %z yon pax))  ~
      %-  malt
      %+  skim
        %~  tap  by
        =<  q
        %-  aeon-to-yaki
        yon
      |=  {p/path q/lobe}
      ?|  ?=(~ pax)
          ?&  !?=(~ p)
              =(-.pax -.p)
              $(p +.p, pax +.pax)
      ==  ==
    ::
    ::  Creates a nako of all the changes between a and b.
    ::
    ++  make-nako
      |=  {a/aeon b/aeon}
      ^-  nako
      :+  ?>  (lte b let.dom)
          |-
          ?:  =(b let.dom)
            hit.dom
          $(hit.dom (~(del by hit.dom) let.dom), let.dom (dec let.dom))
        b
      ?:  =(0 b)
        [~ ~]
      (data-twixt-takos (~(get by hit.dom) a) (aeon-to-tako b))
    ::
    ::  Gets the data between two commit hashes, assuming the first is an
    ::  ancestor of the second.
    ::
    ::  Get all the takos before `a`, then get all takos before `b` except the
    ::  ones we found before `a`.  Then convert the takos to yakis and also get
    ::  all the data in all the yakis.
    ::
    ++  data-twixt-takos
      |=  {a/(unit tako) b/tako}
      ^-  {(set yaki) (set plop)}
      =+  old=?~(a ~ (reachable-takos:util u.a))
      =+  ^-  yal/(set tako)
          %-  silt
          %+  skip
            ~(tap in (reachable-takos:util b))
          |=(tak/tako (~(has in old) tak))
      :-  (silt (turn ~(tap in yal) tako-to-yaki))
      (silt (turn ~(tap in (new-lobes (new-lobes ~ old) yal)) lobe-to-blob))
    ::
    ::  Get all the lobes that are referenced in `a` except those that are
    ::  already in `b`.
    ::
    ++  new-lobes                                       ::  object hash set
      |=  {b/(set lobe) a/(set tako)}                   ::  that aren't in b
      ^-  (set lobe)
      %+  roll  ~(tap in a)
      |=  {tak/tako bar/(set lobe)}
      ^-  (set lobe)
      =+  yak=(tako-to-yaki tak)
      %+  roll  ~(tap by q.yak)
      =<  .(far bar)
      |=  {{path lob/lobe} far/(set lobe)}
      ^-  (set lobe)
      ?~  (~(has in b) lob)                             ::  don't need
        far
      =+  gar=(lobe-to-blob lob)
      ?-  -.gar
        $direct    (~(put in far) lob)
        $delta     (~(put in $(lob q.q.gar)) lob)
      ==
    ::
    ::  Gets the permissions that apply to a particular node.
    ::
    ::  If the node has no permissions of its own, we use its parent's.
    ::  If no permissions have been set for the entire tree above the node,
    ::  we default to fully private (empty whitelist).
    ::
    ++  read-p
      |=  pax/path
      ^-  (unit (unit (each cage lobe)))
      =-  [~ ~ %& %noun !>(-)]
      :-  (read-p-in pax per.red)
      (read-p-in pax pew.red)
    ::
    ++  read-p-in
      |=  {pax/path pes/regs}
      ^-  dict
      =/  rul/(unit rule)  (~(get by pes) pax)
      ?^  rul
        :+  pax  mod.u.rul
        %-  ~(rep in who.u.rul)
        |=  {w/whom out/(pair (set ship) (map @ta crew))}
        ?:  ?=({%& @p} w)
          [(~(put in p.out) +.w) q.out]
        =/  cru/(unit crew)  (~(get by cez.ruf) +.w)
        ?~  cru  out
        [p.out (~(put by q.out) +.w u.cru)]
      ?~  pax  [/ %white ~ ~]
      $(pax (scag (dec (lent pax)) `path`pax))
    ::
    ++  may-read
      |=  {who/ship car/care yon/aeon pax/path}
      ^-  ?
      ?+  car
        (allowed-by who pax per.red)
      ::
          $p
        =(who our)
      ::
          ?($y $z)
        =+  tak=(~(get by hit.dom) yon)
        ?~  tak  |
        =+  yak=(tako-to-yaki u.tak)
        =+  len=(lent pax)
        =-  (levy ~(tap in -) |=(p/path (allowed-by who p per.red)))
        %+  roll  ~(tap in (~(del in ~(key by q.yak)) pax))
        |=  {p/path s/(set path)}
        ?.  =(pax (scag len p))  s
        %-  ~(put in s)
        ?:  ?=($z car)  p
        (scag +(len) p)
      ==
    ::
    ++  may-write
      |=  {w/ship p/path}
      (allowed-by w p pew.red)
    ::
    ++  allowed-by
      |=  {who/ship pax/path pes/regs}
      ^-  ?
      =/  rul/real  rul:(read-p-in pax pes)
      =/  in-list/?
        ?|  (~(has in p.who.rul) who)
          ::
            %-  ~(rep by q.who.rul)
            |=  {{@ta cru/crew} out/_|}
            ?:  out  &
            (~(has in cru) who)
        ==
      ?:  =(%black mod.rul)
        !in-list
      in-list
    ::  +read-t: produce the list of paths within a yaki with :pax as prefix
    ::
    ++  read-t
      |=  [yon=aeon pax=path]
      ^-  (unit (unit [%file-list (hypo (list path))]))
      ::  if asked for version 0, produce an empty list of files
      ::
      ?:  =(0 yon)
        ``[%file-list -:!>(*(list path)) *(list path)]
      ::  if asked for a future version, we don't have an answer
      ::
      ?~  tak=(~(get by hit.dom) yon)
        ~
      ::  look up the yaki snapshot based on the version
      ::
      =/  yak=yaki  (tako-to-yaki u.tak)
      ::  calculate the path length once outside the loop
      ::
      =/  path-length  (lent pax)
      ::
      :^  ~  ~  %file-list
      :-  -:!>(*(list path))
      ^-  (list path)
      ::  sort the matching paths alphabetically
      ::
      =-  (sort - aor)
      ::  traverse the filesystem, filtering for paths with :pax as prefix
      ::
      %+  skim  ~(tap in ~(key by q.yak))
      |=(paf=path =(pax (scag path-length paf)))
    ::
    ::  Checks for existence of a node at an aeon.
    ::
    ::  This checks for existence of content at the node, and does *not* look
    ::  at any of its children.
    ::
    ++  read-u
      |=  {yon/aeon pax/path}
      ^-  (unit (unit (each {$null (hypo ~)} lobe)))
      =+  tak=(~(get by hit.dom) yon)
      ?~  tak
        ~
      ``[%& %null [%atom %n ~] ~]
    ::
    ::  Gets the dome (desk state) at a particular aeon.
    ::
    ::  For past aeons, we don't give an actual ankh in the dome, but the rest
    ::  of the data is legit. We also never send the mime cache over the wire.
    ::
    ++  read-v
      |=  {yon/aeon pax/path}
      ^-  (unit (unit {$dome (hypo dome:clay)}))
      ?:  (lth yon let.dom)
        :*  ~  ~  %dome  -:!>(%dome)
            ^-  dome:clay
            :*  ank=`[[%ank-in-old-v-not-implemented *ankh] ~ ~]
                let=yon
                hit=(molt (skim ~(tap by hit.dom) |=({p/@ud *} (lte p yon))))
                lab=(molt (skim ~(tap by lab.dom) |=({* p/@ud} (lte p yon))))
        ==  ==
      ?:  (gth yon let.dom)
        ~
      ``[%dome -:!>(*dome:clay) [ank let hit lab]:dom]
    ::
    ::  Gets all cases refering to the same revision as the given case.
    ::
    ::  For the %da case, we give just the canonical timestamp of the revision.
    ::
    ++  read-w
      |=  cas/case
      ^-  (unit (unit (each cage lobe)))
      =+  aey=(case-to-aeon cas)
      ?~  aey  ~
      =-  [~ ~ %& %cass !>(-)]
      ^-  cass
      :-  u.aey
      ?:  =(0 u.aey)  `@da`0
      t:(aeon-to-yaki u.aey)
    ::
    ::  Gets the data at a node.
    ::
    ++  read-x  (cury read-x:util ?=(~ ref))
    ::
    ::  Gets an arch (directory listing) at a node.
    ::
    ++  read-y
      |=  {yon/aeon pax/path}
      ^-  (unit (unit {$arch (hypo arch)}))
      ?:  =(0 yon)
        ``[%arch -:!>(*arch) *arch]
      =+  tak=(~(get by hit.dom) yon)
      ?~  tak
        ~
      =+  yak=(tako-to-yaki u.tak)
      =+  len=(lent pax)
      :^  ~  ~  %arch
      ::  ~&  cy+pax
      :-  -:!>(*arch)
      ^-  arch
      :-  (~(get by q.yak) pax)
      ^-  (map knot ~)
      %-  molt  ^-  (list (pair knot ~))
      %+  turn
        ^-  (list (pair path lobe))
        %+  skim  ~(tap by (~(del by q.yak) pax))
        |=  {paf/path lob/lobe}
        =(pax (scag len paf))
      |=  {paf/path lob/lobe}
      =+  pat=(slag len paf)
      [?>(?=(^ pat) i.pat) ~]
    ::
    ::  Gets a recursive hash of a node and all its children.
    ::
    ++  read-z
      |=  {yon/aeon pax/path}
      ^-  (unit (unit {$uvi (hypo @uvI)}))
      ?:  =(0 yon)
        ``uvi+[-:!>(*@uvI) *@uvI]
      =+  tak=(~(get by hit.dom) yon)
      ?~  tak
        ~
      =+  yak=(tako-to-yaki u.tak)
      =+  len=(lent pax)
      :: ~&  read-z+[yon=yon qyt=~(wyt by q.yak) pax=pax]
      =+  ^-  descendants/(list (pair path lobe))
          ::  ~&  %turning
          ::  =-  ~&  %turned  -
          %+  turn
            ::  ~&  %skimming
            ::  =-  ~&  %skimmed  -
            %+  skim  ~(tap by (~(del by q.yak) pax))
            |=  {paf/path lob/lobe}
            =(pax (scag len paf))
          |=  {paf/path lob/lobe}
          [(slag len paf) lob]
      =+  us=(~(get by q.yak) pax)
      ^-  (unit (unit {$uvi (hypo @uvI)}))
      :^  ~  ~  %uvi
      :-  -:!>(*@uvI)
      ?:  &(?=(~ descendants) ?=(~ us))
        *@uvI
      %+  roll
        ^-  (list (pair path lobe))
        [[~ ?~(us *lobe u.us)] descendants]
      |=({{path lobe} @uvI} (shax (jam +<)))
    ::
    ::  Get a value at an aeon.
    ::
    ::  Value can be either null, meaning we don't have it yet, {null null},
    ::  meaning we know it doesn't exist, or {null null (each cage lobe)},
    ::  meaning we either have the value directly or a content hash of the
    ::  value.
    ::
    ++  read-at-aeon                                    ::    read-at-aeon:ze
      |=  [for=(unit ship) yon=aeon mun=mood]           ::  seek and read
      ^-  (unit (unit (each cage lobe)))
      ?.  |(?=(~ for) (may-read u.for p.mun yon r.mun))
        ~
      ?-  p.mun
          %d
        ::  XX this should only allow reads at the current date
        ::
        ?:  !=(our her)
          [~ ~]
        ?^  r.mun
          ~&(%no-cd-path [~ ~])
        [~ ~ %& %noun !>(~(key by dos.rom.ruf))]
      ::
        %p  (read-p r.mun)
        %t  (bind (read-t yon r.mun) (lift |=(a=cage [%& a])))
        %u  (read-u yon r.mun)
        %v  (bind (read-v yon r.mun) (lift |=(a/cage [%& a])))
        %w  (read-w q.mun)
        %x  (read-x yon r.mun)
        %y  (bind (read-y yon r.mun) (lift |=(a/cage [%& a])))
        %z  (bind (read-z yon r.mun) (lift |=(a/cage [%& a])))
      ==
    ++  zu  zu:util
    --
  --
--
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::              section 4cA, filesystem vane
::
::  This is the arvo interface vane.  Our formal state is a `++raft`, which
::  has five components:
::
::  --  `rom` is the state for all local desks.
::  --  `hoy` is the state for all foreign desks.
::  --  `ran` is the global, hash-addressed object store.
::  --  `mon` is the set of mount points in unix.
::  --  `hez` is the duct to the unix sync.
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
=|                                                    ::  instrument state
    $:  ver=%1                                        ::  vane version
        ruf=raft                                      ::  revision tree
    ==                                                ::
|=  [our=ship now=@da eny=@uvJ ski=sley]              ::  current invocation
^?                                                    ::  opaque core
|%                                                    ::
++  call                                              ::  handle request
  |=  $:  hen=duct
          type=*
          wrapped-task=(hobo task:able)
      ==
  ^-  [(list move) _..^$]
  ::
  =/  req=task:able
    ?.  ?=(%soft -.wrapped-task)
      wrapped-task
    ;;(task:able p.wrapped-task)
  ::
  ::  only one of these should be going at once, so queue
  ::
  ?:  ?=(?(%info %merg) -.req)
    ::  If there's an active write or a queue, enqueue
    ::
    ::    We only want one active write so each can be a clean
    ::    transaction.  We don't intercept `%into` because it
    ::    immediately translates itself into one or two `%info` calls.
    ::
    ?:  |(!=(~ act.ruf) !=(~ cue.ruf))
      =.  cue.ruf  (~(put to cue.ruf) [hen req])
      ::  ~&  :*  %clall-enqueing
      ::          cue=(turn ~(tap to cue.ruf) |=([=duct =task:able] [duct -.task]))
      ::          ^=  act
      ::          ?~  act.ruf
      ::            ~
      ::          [hen req -.cad]:u.act.ruf
      ::      ==
      [~ ..^$]
    ::  If the last commit happened in this event, enqueue
    ::
    ::    Without this, two commits could have the same date, which
    ::    would make clay violate referential transparency.
    ::
    =/  =desk  des.req
    =/  =dojo  (fall (~(get by dos.rom.ruf) desk) *dojo)
    ?:  =(0 let.dom.dojo)
      (handle-task hen req)
    =/  sutil  (state:util dom.dojo dom.dojo ran.ruf)
    =/  last-write=@da  t:(aeon-to-yaki:sutil let.dom.dojo)
    ?:  !=(last-write now)
      (handle-task hen req)
    =.  cue.ruf  (~(put to cue.ruf) [hen req])
    =/  wait-behn  [hen %pass /queued-request %b %wait now]
    [[wait-behn ~] ..^$]
  (handle-task hen req)
::
::  Handle a task, without worrying about write queueing
::
++  handle-task
  |=  [hen=duct req=task:able]
  ^-  [(list move) _..^$]
  ?-    -.req
      %boat
    :_  ..^$
    [hen %give %hill (turn ~(tap by mon.ruf) head)]~
  ::.
      %cred
    =.  cez.ruf
      ?~  cew.req  (~(del by cez.ruf) nom.req)
      (~(put by cez.ruf) nom.req cew.req)
    ::  wake all desks, a request may have been affected.
    =|  mos/(list move)
    =/  des  ~(tap in ~(key by dos.rom.ruf))
    |-
    ?~  des  [[[hen %give %mack ~] mos] ..^^$]
    =/  den  ((de our now ski hen ruf) our i.des)
    =^  mor  ruf
      =<  abet:wake
      ?:  ?=(^ cew.req)  den
      (forget-crew:den nom.req)
    $(des t.des, mos (weld mos mor))
  ::
      %crew
    [[hen %give %cruz cez.ruf]~ ..^$]
  ::
      %crow
    =/  des  ~(tap by dos.rom.ruf)
    =|  rus/(map desk {r/regs w/regs})
    |^
      ?~  des  [[hen %give %croz rus]~ ..^^$]
      =+  per=(filter-rules per.q.i.des)
      =+  pew=(filter-rules pew.q.i.des)
      =?  rus  |(?=(^ per) ?=(^ pew))
        (~(put by rus) p.i.des per pew)
      $(des t.des)
    ::
    ++  filter-rules
      |=  pes/regs
      ^+  pes
      =-  (~(gas in *regs) -)
      %+  skim  ~(tap by pes)
      |=  {p/path r/rule}
      (~(has in who.r) |+nom.req)
    --
  ::
      %crud
    [[[hen %slip %d %flog req] ~] ..^$]
  ::
      %drop
    =^  mos  ruf
      =/  den  ((de our now ski hen ruf) our des.req)
      abet:drop-me:den
    [mos ..^$]
  ::
      %info
    ?:  =(%$ des.req)
      ~|(%info-no-desk !!)
    =/  =dojo  (fall (~(get by dos.rom.ruf) des.req) *dojo)
    =.  act.ruf
      =/  writer=form:commit-clad
        %-  %-  commit
            :*  our
                des.req
                now
                mon.ruf
                hez.ruf
                hun.rom.ruf
            ==
        :*  dit.req
            dom.dojo
            ran.ruf
        ==
      `[hen req %commit ~ writer]
    =^  mos  ruf
      =/  den  ((de our now ski hen ruf) our des.req)
      abet:(take-commit:den [%y %init-clad ~])
    [mos ..^$]
  ::
      %init
    [~ ..^$(hun.rom.ruf hen)]
  ::
      %into
    =.  hez.ruf  `hen
    :_  ..^$
    =+  bem=(~(get by mon.ruf) des.req)
    ?:  &(?=(~ bem) !=(%$ des.req))
      ~|([%bad-mount-point-from-unix des.req] !!)
    =+  ^-  bem/beam
        ?^  bem
          u.bem
        [[our %base %ud 1] ~]
    =/  dos  (~(get by dos.rom.ruf) q.bem)
    ?~  dos
      !!  ::  fire next in queue
    ?:  =(0 let.dom.u.dos)
      =+  cos=(mode-to-soba ~ s.bem all.req fis.req)
      =+  ^-  [one=soba two=soba]
          %+  skid  cos
          |=  [a=path b=miso]
          ?&  ?=(%ins -.b)
              ?=(%mime p.p.b)
              ?=([%hoon ~] (slag (dec (lent a)) a))
          ==
      :~  [hen %pass /one %c %info q.bem %& one]
          [hen %pass /two %c %info q.bem %& two]
      ==
    =+  yak=(~(got by hut.ran.ruf) (~(got by hit.dom.u.dos) let.dom.u.dos))
    =+  cos=(mode-to-soba q.yak (flop s.bem) all.req fis.req)
    [hen %pass /both %c %info q.bem %& cos]~
  ::
      %merg                                               ::  direct state up
    ?:  =(%$ des.req)
      ~&(%merg-no-desk !!)
    =/  =dojo  (fall (~(get by dos.rom.ruf) des.req) *dojo)
    =.  act.ruf
      =/  writer=form:merge-clad
        %-  %-  merge
            :*  our
                now
                [her dem]:req
                [our des.req]
                cas.req
                mon.ruf
                hez.ruf
            ==
        :*  how.req
            dom.dojo
            ran.ruf
        ==
      `[hen req %merge ~ writer]
    =^  mos  ruf
      =/  den  ((de our now ski hen ruf) our des.req)
      abet:(take-merge:den [%y %init-clad ~])
    [mos ..^$]
  ::
      %mont
    =.  hez.ruf  ?^(hez.ruf hez.ruf `[[%$ %sync ~] ~])
    =+  pot=(~(get by mon.ruf) des.req)
    ?^  pot
      ~&  [%already-mounted pot]
      [~ ..^$]
    =*  bem  bem.req
    =.  mon.ruf
      (~(put by mon.ruf) des.req [p.bem q.bem r.bem] s.bem)
    =/  dos  (~(get by dos.rom.ruf) q.bem)
    ?~  dos
      [~ ..^$]
    =^  mos  ruf
      =/  den  ((de our now ski hen ruf) p.bem q.bem)
      abet:(mont:den des.req bem)
    [mos ..^$]
  ::
      %dirk
    ?~  hez.ruf
      ~&  %no-sync-duct
      [~ ..^$]
    ?.  (~(has by mon.ruf) des.req)
      ~&  [%not-mounted des.req]
      [~ ..^$]
    :-  ~[[u.hez.ruf %give %dirk des.req]]
        ..^$
  ::
      %ogre
    ?~  hez.ruf
      ~&  %no-sync-duct
      [~ ..^$]
    =*  pot  pot.req
    ?@  pot
      ?.  (~(has by mon.ruf) pot)
        ~&  [%not-mounted pot]
        [~ ..^$]
      :_  ..^$(mon.ruf (~(del by mon.ruf) pot))
      [u.hez.ruf %give %ogre pot]~
    :_  %_    ..^$
            mon.ruf
          %-  molt
          %+  skip  ~(tap by mon.ruf)
          (corl (cury test pot) tail)
        ==
    %+  turn
      (skim ~(tap by mon.ruf) (corl (cury test pot) tail))
    |=  {pon/term bem/beam}
    [u.hez.ruf %give %ogre pon]
  ::
      %perm
    =^  mos  ruf
      =/  den  ((de our now ski hen ruf) our des.req)
      abet:(perm:den pax.req rit.req)
    [mos ..^$]
  ::
      %sunk
    ~&  rift=[p.req q.req]
    ~&  desks=(turn ~(tap by dos.rom.ruf) head)
    ~&  hoy=(turn ~(tap by hoy.ruf) head)
    ::
    ?:  =(our p.req)
      [~ ..^$]
    ::  Cancel subscriptions
    ::
    =/  foreign-desk=(unit rung)
      (~(get by hoy.ruf) p.req)
    ?~  foreign-desk
      ~&  [%never-heard-of-her p.req q.req]
      [~ ..^$]
    ~&  old-rift=rit.u.foreign-desk
    ?:  (gte rit.u.foreign-desk q.req)
      ~&  'replaying sunk, so not clearing state'
      [~ ..^$]
    =/  cancel-ducts=(list duct)
      %-  zing  ^-  (list (list duct))
      %+  turn  ~(tap by rus.u.foreign-desk)
      |=  [=desk =rede]
      %+  weld
        ^-  (list duct)  %-  zing  ^-  (list (list duct))
        %+  turn  ~(tap by qyx.rede)
        |=  [=wove ducts=(set duct)]
        ~(tap in ducts)
      ?~  ref.rede
        ~
      (turn ~(tap by fod.u.ref.rede) head)
    =/  cancel-moves=(list move)
      %+  turn  cancel-ducts
      |=  =duct
      [duct %slip %b %drip !>([%writ ~])]
    ::  Clear ford cache
    ::
    =/  clear-ford-cache-moves=(list move)
      :~  [hen %pass /clear/keep %f %keep 0 1]
          [hen %pass /clear/wipe %f %wipe 100]
          [hen %pass /clear/kep %f %keep 2.048 64]
      ==
    ::  delete local state of foreign desk
    ::
    =.  hoy.ruf  (~(del by hoy.ruf) p.req)
    [(weld clear-ford-cache-moves cancel-moves) ..^$]
  ::
      %vega  [~ ..^$]
  ::
      ?(%warp %werp)
    ::  capture whether this read is on behalf of another ship
    ::  for permissions enforcement
    ::
    =^  for  req
      ?:  ?=(%warp -.req)
        [~ req]
      :-  ?:(=(our who.req) ~ `who.req)
      [%warp wer.req rif.req]
    ::
    ?>  ?=(%warp -.req)
    =*  rif  rif.req
    =^  mos  ruf
      =/  den  ((de our now ski hen ruf) wer.req p.rif)
      =<  abet
      ?~  q.rif
        cancel-request:den
      (start-request:den for u.q.rif)
    [mos ..^$]
  ::
      %west
    =*  wer  wer.req
    =*  pax  pax.req
    ?:  ?=({%question *} pax)
      =+  ryf=;;(riff res.req)
      :_  ..^$
      :~  [hen %give %mack ~]
          =/  =wire
            [(scot %p our) (scot %p wer) t.pax]
          [hen %pass wire %c %werp wer our ryf]
      ==
    ?>  ?=({%answer @ @ ~} pax)
    =+  syd=(slav %tas i.t.pax)
    =+  inx=(slav %ud i.t.t.pax)
    =^  mos  ruf
      =/  den  ((de our now ski hen ruf) wer syd)
      abet:(take-foreign-update:den inx ;;((unit rand) res.req))
    [[[hen %give %mack ~] mos] ..^$]
  ::
      %wegh
    :_  ..^$  :_  ~
    :^  hen  %give  %mass
    :+  %clay  %|
    :~  domestic+&+rom.ruf
        foreign+&+hoy.ruf
        :+  %object-store  %|
        :~  commits+&+hut.ran.ruf
            blobs+&+lat.ran.ruf
        ==
        dot+&+ruf
    ==
  ==
::
++  load
  =>  |%
      +$  axle  [%1 ruf-1=raft]
      --
  ::  |=  *
  ::  ..^$
  ::  XX switch back
  |=  old=axle
  ^+  ..^$
  ?>  ?=(%1 -.old)
  %_(..^$ ruf ruf-1.old)
::
++  scry                                              ::  inspect
  |=  {fur/(unit (set monk)) ren/@tas why/shop syd/desk lot/coin tyl/path}
  ^-  (unit (unit cage))
  ?.  ?=(%& -.why)  ~
  =*  his  p.why
  ::  ~&  scry+[ren `path`[(scot %p his) syd ~(rent co lot) tyl]]
  ::  =-  ~&  %scry-done  -
  =+  luk=?.(?=(%$ -.lot) ~ ((soft case) p.lot))
  ?~  luk  [~ ~]
  ?:  =(%$ ren)
    [~ ~]
  =+  run=((soft care) ren)
  ?~  run  [~ ~]
  ::TODO  if it ever gets filled properly, pass in the full fur.
  =/  for/(unit ship)
    %-  ~(rep in (fall fur ~))
    |=  {m/monk s/(unit ship)}
    ?^  s  s
    ?:  ?=(%| -.m)  ~
    ?:  =(p.m his)  ~
    `p.m
  =/  den  ((de our now ski [/scryduct ~] ruf) his syd)
  =+  (aver:den for u.run u.luk tyl)
  ?~  -               -
  ?~  u.-             -
  ?:  ?=(%& -.u.u.-)  ``p.u.u.-
  ~
::
++  stay  [%1 ruf]
++  take                                              ::  accept response
  |=  {tea/wire hen/duct hin/(hypo sign)}
  ^+  [*(list move) ..^$]
  ?:  ?=({$commit @ *} tea)
    =*  syd  i.t.tea
    =^  mos  ruf
      =/  den  ((de our now ski hen ruf) our syd)
      abet:(take-commit:den q.hin)
    [mos ..^$]
  ?:  ?=({$merge @ *} tea)
    =*  syd  i.t.tea
    =^  mos  ruf
      =/  den  ((de our now ski hen ruf) our syd)
      abet:(take-merge:den q.hin)
    [mos ..^$]
  ?:  ?=({$blab care @ @ *} tea)
    ?>  ?=($made +<.q.hin)
    ?.  ?=([%complete %success *] result.q.hin)
      ~|  %blab-fail
      ~>  %mean.|.((made-result-as-error:ford result.q.hin))
      !!                              ::  interpolate ford fail into stack trace
    :_  ..^$  :_  ~
    :*  hen  %slip  %b  %drip  !>
    :*  %writ  ~
        ^-  {care case @tas}
        [i.t.tea ;;(case +>:(slay i.t.t.tea)) i.t.t.t.tea]
    ::
        `path`t.t.t.t.tea
        `cage`(result-to-cage:ford build-result.result.q.hin)
    ==  ==
  ?-    -.+.q.hin
      %init-clad
    ~|(%clad-not-real !!)
  ::
      %crud
    [[[hen %slip %d %flog +.q.hin] ~] ..^$]
  ::
      %made
    ?~  tea  !!
    ?+    -.tea  !!
        $ergoing
      ?>  ?=({@ @ ~} t.tea)
      =+  syd=(slav %tas i.t.t.tea)
      =^  mos  ruf
        =/  den  ((de our now ski hen ruf) our syd)
        abet:(take-ergo:den result.q.hin)
      [mos ..^$]
    ::
        %foreign-plops
      ?>  ?=({@ @ @ @ ~} t.tea)
      =+  her=(slav %p i.t.t.tea)
      =*  syd  i.t.t.t.tea
      =+  lem=(slav %da i.t.t.t.t.tea)
      =^  mos  ruf
        =/  den  ((de our now ski hen ruf) her syd)
        abet:(take-foreign-plops:den ?~(lem ~ `lem) result.q.hin)
      [mos ..^$]
    ::
        %foreign-x
      ?>  ?=({@ @ @ @ @ *} t.tea)
      =+  her=(slav %p i.t.t.tea)
      =+  syd=(slav %tas i.t.t.t.tea)
      =+  car=;;(care i.t.t.t.t.tea)
      =+  ^-  cas/case
          =+  (slay i.t.t.t.t.t.tea)
          ?>  ?=({~ %$ case} -)
          ->+
      =*  pax  t.t.t.t.t.t.tea
      =^  mos  ruf
        =/  den  ((de our now ski hen ruf) her syd)
        abet:(take-foreign-x:den car cas pax result.q.hin)
      [mos ..^$]
    ==
  ::
      %mere
    ?:  ?=(%& -.p.+.q.hin)
      ~&  'initial merge succeeded'
      [~ ..^$]
    ~>  %slog.
        :^  0  %rose  [" " "[" "]"]
        :^    leaf+"initial merge failed"
            leaf+"my most sincere apologies"
          >p.p.p.+.q.hin<
        q.p.p.+.q.hin
    [~ ..^$]
  ::
      %note  [[hen %give +.q.hin]~ ..^$]
      %wake
    ::  TODO: handle behn errors
    ::
    ?^  error.q.hin
      [[hen %slip %d %flog %crud %wake u.error.q.hin]~ ..^$]
    ::
    ?:  ?=([%tyme ~] tea)
      ~&  %out-of-tyme
      `..^$
    ::  dear reader, if it crashes here, check the wire.  If it came
    ::  from ++bait, then I don't think we have any handling for that
    ::  sort of thing.
    ::
    =^  queued  cue.ruf  ~(get to cue.ruf)
    ::
    =/  queued-duct=duct       -.queued
    =/  queued-task=task:able  +.queued
    ::
    ::  ~&  :*  %clay-waking
    ::          queued-duct
    ::          hen
    ::          ?~(cue.ruf /empty -:(need ~(top to cue.ruf)))
    ::      ==
    ~|  [%mismatched-ducts %queued queued-duct %timer hen]
    ?>  =(hen queued-duct)
    ::
    (handle-task hen queued-task)
  ::
      %writ
    ?>  ?=({@ @ *} tea)
    ~|  i=i.tea
    ~|  it=i.t.tea
    =+  him=(slav %p i.t.tea)
    :_  ..^$
    :~  :*  hen  %pass  /writ-want  %a
            %want  him  [%c %answer t.t.tea]
            (bind p.+.q.hin rant-to-rand)
        ==
    ==
  ::
      %send
    [[[hen %give +.q.hin] ~] ..^$]
  ::
      %woot
    ?~  q.q.hin
      [~ ..^$]
    ~&  [%clay-lost p.q.hin tea]
    ?~  u.q.q.hin
      [~ ..^$]
    %-  (slog >p.u.u.q.q.hin< q.u.u.q.q.hin)
    [~ ..^$]
  ==
::
++  rant-to-rand
  |=  rant
  ^-  rand
  [p q [p q.q]:r]
::
++  mode-to-soba
  |=  {hat/(map path lobe) pax/path all/? mod/mode}
  ^-  soba
  %+  weld
    ^-  (list (pair path miso))
    ?.  all
      ~
    =+  mad=(malt mod)
    =+  len=(lent pax)
    =+  ^-  descendants/(list path)
        %+  turn
          %+  skim  ~(tap by hat)
          |=  {paf/path lob/lobe}
          =(pax (scag len paf))
        |=  {paf/path lob/lobe}
        (slag len paf)
    %+  murn
      descendants
    |=  pat/path
    ^-  (unit (pair path {$del ~}))
    ?:  (~(has by mad) pat)
      ~
    `[(weld pax pat) %del ~]
  ^-  (list (pair path miso))
  %+  murn  mod
  |=  {pat/path mim/(unit mime)}
  ^-  (unit (pair path miso))
  =+  paf=(weld pax pat)
  ?~  mim
    =+  (~(get by hat) paf)
    ?~  -
      ~&  [%deleting-already-gone pax pat]
      ~
    `[paf %del ~]
  =+  (~(get by hat) paf)
  ?~  -
    `[paf %ins %mime -:!>(*mime) u.mim]
  `[paf %mut %mime -:!>(*mime) u.mim]
::  +rift-scry: for a +rift
::
++  rift-scry
  ~%  %rift-scry  ..is  ~
  |=  who=ship
  ^-  (unit rift)
  =;  lyf
    ?~(lyf ~ u.lyf)
  ;;  (unit (unit rift))
  %-  (sloy-light ski)
  =/  pur=spur
    /(scot %p who)
  [[151 %noun] %j our %rift da+now pur]
--
