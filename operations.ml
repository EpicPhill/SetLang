type word = bytes;;
type lang = word list;;
type expr = 
	| None
	| Lang of lang
	| LitI of int
	| Input of lang list * int
let fst_input = function
	|Input(l,i) -> l | _ -> failwith "not an input type";;
let snd_input = function
	|Input(l,i) -> i | _ -> failwith "not an input type";;
let rec append (l:lang) (c:char) = match l with
	| h::t -> (h^(String.make 1 c)) :: append t c
	| smaller -> smaller;;
let order (l:lang) = List.sort compare l;;
let reverse (l:lang) = List.rev l;;
let contains (l:lang) (w:word) = List.exists (fun e -> e = w) l;;
let rec union (l1:lang) (l2:lang) = match l1 with
	| [] -> l2
	| h::t -> if contains l2 h then union t l2 else union t (h::l2);;
let rec intersection (l1:lang) (l2:lang) = match l1 with
	| h::t -> if contains l2 h then h :: intersection t l2 else intersection t l2
	| smaller -> smaller;;
let rec removedupes l:lang = match (order l) with
    	| h :: (ht :: _ as t) -> if h = ht then removedupes t else h :: removedupes t
    	| smaller -> smaller;;
let explode s = 
	let rec explodehelper curr exploded =
		if curr < 0 then exploded else 
			explodehelper (curr-1) (s.[curr] :: exploded) in
	explodehelper (String.length s -1) [];;
let makestring (c:char) = String.make 1 c;;
let rec add_char_to_last l c = match l with
	| [] -> []
	| e :: [] -> [e^makestring c]
	| h :: t -> h::add_char_to_last t c;;
let get_random_element l = List.nth l (Random.int (List.length l));;
let rec pow x y = match (x,y) with
	| (_,0) 
	| (1,_) -> 1
	| (_,1) -> x
	| (x,y) -> x*(pow x (y-1));;
let convertlang l = 
	let rec converthelper (stringlist: char list) combo = match stringlist with
		| [] | _::[] -> combo
		| a :: ('}' :: _ ) -> combo 
		| '{' :: ( e :: _ as t ) -> converthelper t [makestring e] 
		| ',' :: ( e :: _ as t ) -> converthelper t (combo@[makestring e])
		| a :: ( ',' :: _ as t ) -> converthelper t combo
		| a :: ( e :: _ as t) -> converthelper t (add_char_to_last combo e) in
	converthelper (explode l) [];;
let processline line = 
	if (line.[0] = '{') then
		(Lang (convertlang line))
	else 
		(LitI (int_of_string line));;
let rec print_list_nicely = function
	| [] -> () 
	| h::[] -> print_string h
	| h::t -> print_string h ; print_string "," ; print_list_nicely t ;;
let prettyprint = function
	| (LitI i) -> print_int i
	| (Lang l) -> print_char '{'; print_list_nicely l; print_char '}';;
let rec concat_single (l:lang)  (c:char)  (i:int) = match (l,i) with
	| (_,0) -> reverse l
	| (h::t,_) -> concat_single ((h^(makestring c))::l) c (i-1);;
let rec newword (cl:lang) (wl:int) = match wl with
	| 0 -> ""
	| _ -> get_random_element cl ^ newword cl (wl-1);;
let conswords (cl:lang) (wl:int) = 
	let rec conwordinner (combo:lang) (length:int) =
		if (List.length combo == length) then combo else let nw = newword cl wl in if (List.mem nw combo) then conwordinner combo length else conwordinner (nw::combo) length in
	order (conwordinner [] (pow (List.length cl) wl));; 	
let rec concat_multi (l1:lang) (l2:lang) (i:int) = match (l1,l2,i) with
	| (_,_,0) -> []
	| (h1::t1,h2::t2,_) -> (h1^h2)::(concat_multi l1 t2 (i-1));;
let readin = fun () ->
	try
		let rec read langlist =
			let line = input_line stdin in
				let processed = processline line in
				match (processed) with
					| (LitI i) -> Input (langlist,i)
					| (Lang l) -> read (langlist@[l])
		in read []
	with
		End_of_file -> None;;
