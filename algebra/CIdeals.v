(* Ideals.v, v1.0, 28april2004, Bart Kirkels *)

(** printing [+] %\ensuremath+% #+# *)
(** printing [*] %\ensuremath\times% #&times;# *)
(** printing ['] %\ensuremath.% #.# *)
(** printing [-] %\ensuremath{-}% #&minus;# *)
(** printing [--] %\ensuremath-% #&minus;# *)
(** printing [=] %\ensuremath=% #&equiv;# *)
(** printing [#] %\ensuremath\#% *)
(** printing Zero %\ensuremath{\mathbf0}% #0# *)
(** printing One %\ensuremath{\mathbf1}% #1# *)

Require Export CRings.

(**
* Ideals and coideals 
** Definition of ideals and coideals
Let [R] be a ring. At this moment all CRings are commutative and
non-trivial. So our ideals are automatically two-sided. As soon 
as non-commutative rings are represented in CoRN left and 
right ideals should be defined.
*)

Section Ideals.

Variable R : CRing.

Record is_ideal (idP : wd_pred R) : CProp :=
  { idax : forall a x:R, idP a -> idP (a[*]x);
    idprpl : forall x y : R, idP x -> idP y -> idP (x[+]y)}.
  
Record ideal : Type :=
  { idpred :> wd_pred R;
    idproof : is_ideal idpred}.

(* begin hide *)
Variable I : ideal.
Definition ideal_as_CSetoid := Build_SubCSetoid R I.
(* end hide *)

(** 
We actually define strongly non-trivival co-ideals. 
*)

Record is_coideal (ciP : wd_pred R) : CProp :=
  { ciapzero : forall x:R, ciP x -> x[#]Zero;
    ciplus : forall x y:R, ciP (x[+]y) -> ciP x or ciP y;
    cimult : forall x y:R, ciP (x[*]y) -> ciP x and ciP y;
    cinontriv : ciP One}.
    
Record coideal : Type :=
  { cipred :> wd_pred R;
    ciproof : is_coideal cipred}.
    
(* begin hide *)
Variable C : coideal.
Definition coideal_as_CSetoid := Build_SubCSetoid R C.
(* end hide *)

End Ideals.

Implicit Arguments is_ideal [R].
Implicit Arguments is_coideal [R].

(**
%\newpage%
** Axioms of ideals and coideals
Let [R] be a ring, [I] and ideal of [R] and [C] a coideal of [R].
*)

Section Ideal_Axioms.

Variable R : CRing.
Variable I : ideal R.
Variable C : coideal R.

Lemma ideal_is_ideal : is_ideal I.
elim I; auto.
Qed.

Lemma coideal_is_coideal : is_coideal C.
elim C; auto.
Qed.

Lemma coideal_apzero : forall x:R, C x -> x[#]Zero.
elim C. intuition elim ciproof0.
Qed.

Lemma coideal_nonzero : Not (C Zero).
intro.
cut ((Zero:R)[#](Zero:R)); try apply coideal_apzero; try assumption.
apply ap_irreflexive.
Qed.

Lemma coideal_plus : forall x y:R, C (x[+]y) -> C x or C y.
elim C. intuition elim ciproof0.
Qed.

Lemma coideal_mult : forall x y:R, C (x[*]y) -> C x and C y.
elim C. intuition elim ciproof0.
Qed.

Lemma coideal_nontriv : C One.
elim C. intuition elim ciproof0.
Qed.

Lemma coideal_wd : forall x y:R, x[=]y -> C x -> C y.
elim C. simpl in |-*. intro.
elim cipred0. intros.
apply (wdp_well_def x y); auto.
Qed.

End Ideal_Axioms.

Hint Resolve coideal_apzero coideal_nonzero coideal_plus: algebra.
Hint Resolve coideal_mult coideal_wd coideal_nontriv: algebra.