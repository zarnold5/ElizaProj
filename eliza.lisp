;;; -*- Mode: Lisp; Syntax: Common-Lisp; -*-
;;; Code from Paradigms of Artificial Intelligence Programming
;;; Copyright (c) 1991 Peter Norvig

;;;; File eliza.lisp: Advanced version of Eliza.
;;; Has more rules, and accepts input without parens.

;(requires "eliza1")
(load "auxfns")
(load "eliza1")
;;; ==============================

(defun read-line-no-punct ()
  "Read an input line, ignoring punctuation."
  (read-from-string
    (concatenate 'string "(" (substitute-if #\space #'punctuation-p
                                            (read-line))
                 ")")))

(defun punctuation-p (char) (find char ".,;:`!?#-()\\\""))

;;; ==============================

;;; we are using this function to fix apostophes in the input
(defun quote-replace (input)
  (if (>= (length input) 2)
      (cond
       ((and (equal (first input) 'don)
	     (equal (second input) (quote 't)))
	   (append '(do not) (synonym-replace (cdr (cdr input)))))
       ((and (equal (first input) 'i)
	     (equal (second input) (quote 'm)))
	   (append '(i am) (synonym-replace (cdr (cdr input)))))
       ((and (equal (first input) 'isn)
	     (equal (second input) (quote 't)))
	   (append '(is not) (synonym-replace (cdr (cdr input)))))
       ((and (equal (first input) 'you)
	     (equal (second input) (quote 're)))
	   (append '(you are) (synonym-replace (cdr (cdr input)))))
       ((equal (first input) (quote 's))
	(cons 'is (synonym-replace (cdr input))))
       (T (cons (first input) (synonym-replace (cdr input)))))
    input)
  )

(defun synonym-replace (input)
  (sublis '(
	    (nope . no)
	    )
          input))

;;; changed to use the fixed-input when calling use-eliza-rules
(defun jules ()
  "Respond to user input using pattern matching rules."
  (loop
    (print 'Jules>)
    (let* ((input (read-line-no-punct))
	   (fixed-input (quote-replace (synonym-replace input)))
           (response (flatten (use-eliza-rules fixed-input))))
      (princ fixed-input)
      (print-with-spaces response)
      (if (equal response '(good bye)) (RETURN)))))

(defun print-with-spaces (list)
  (mapc #'(lambda (x) (prin1 x) (princ " ")) list))

(defun print-with-spaces (list)
  (format t "~{~a ~}" list))

;;; ==============================

(defun mappend (fn &rest lists)	
  "Apply fn to each element of lists and append the results."
  (apply #'append (apply #'mapcar fn lists)))

;;; ==============================



(defparameter *eliza-rules*
 '((((?* ?x) hello (?* ?y))      
    (Sup motherfucker?))
   ((You are (?* ?y)) (be careful what you say.)(You son of a bitch!))
   (((?* ?x) fuck you (?* ?y))
    (watch yourself motherfucker.)(take that back.))
   ((what)
    (Say what again. Say what again I dare you. I double dare you motherfucker - say what one more Goddamn time!)(What do you mean what?))
   (((?* ?x) bible (?* ?y))
    (There is this one passage in the bible I got memorized. The path of the righteous man is 
	     beset on all sides by the inequities of the selfish and the tyranny of evil men. Blessed is he who 
	     in the name of charity and good will shepherds the weak through the valley of the darkness
	     for he is the keeper of his brother and the finder of lost children. 
	     And I will strike down upon thee with great vengeance and furious anger those who attempt to poison and destroy my brothers. 
	     And you will know my name is The Lord when I lay my vengeance upon thee.
	     I just thought it was some cold-blooded shit to say to a motherfucker before I popped a cap in his ass.))
   (((?* ?x) your name)
    (my name is Jules but you can just consider me a shepherd))
   (((?* ?x) computer (?* ?y))
    (I do not concern myself with computers.)
    (Computeres are the essential tyrany of evil men))
   (((?* ?x) name (?* ?y))
    (I am not interested in names I am just a shepherd))
   (((?* ?x) sorry (?* ?y))
    (Please do not apologize) (Apologies are not necessary)
    (Man have some respect for your self!))
   (((?* ?x) I remember (?* ?y)) 
    (You still remember that huh ?y)
    (Does thinking of ?y bring anything else to mind?)
    (What else do you remember?) (Why do you recall ?y right now?)
    (Why are you wasting my time with the past?))
   (((?* ?x) do you remember (?* ?y))
    (Did you think I would forget ?y ?)
    (How am I supposed to remember that shit?))
   (((?* ?x) if (?* ?y)) 
    (Conditionals are a quick path to the valley of death - my friend) (Really-- if ?y))

   (((?* ?x) I dreamt (?* ?y))
    (Really-- ?y) (I think we all fantasize about ?y)
    (Have you dreamt ?y before?))
   (((?* ?x) dream about (?* ?y))
    (How do you feel about ?y in reality?))
   (((?* ?x) dream (?* ?y))    
    (What does this dream suggest to you?) (Do you dream often?)
    (What persons appear in your dreams?)
    (Don't you believe that dream has to do with your problem?))
   (((?* ?x) my mother (?* ?y))
    (Who else in your family ?y) (Tell me more about your family))
   (((?* ?x) my father (?* ?y))
    (Your father?) (At least you had a father growing up) 
    (What does this have to do with the bussiness at hand?))

   (((?* ?x) I want (?* ?y))     
    (What would it mean if you got ?y)
    (Why do you want ?y) (Suppose you got ?y soon))
   (((?* ?x) I am glad (?* ?y))
    (How have I helped you to be ?y) (What makes you happy just now)
    (Can you explain why you are suddenly ?y))
   (((?* ?x) I am sad (?* ?y))
    (Why are you such a pussy?)
    (Cry me a river.))
   (((?* ?x) are like (?* ?y))   
    (What possible resemblance do you see between ?x and ?y))
   (((?* ?x) is like (?* ?y))    
    (In what way is it that ?x is like ?y?)
    (What resemblance do you see?)
    (Could there really be some connection?) (How?))
   (((?* ?x) alike (?* ?y))      
    (In what way?) (What similarities are there?))
   (((?* ?x) same (?* ?y))       
    (What other connections do you see?))

   (((?* ?x) I was (?* ?y))       
    (Were you really?) (Perhaps I already knew you were ?y)
    (Why do you tell me you were ?y now?))
   (((?* ?x) was I (?* ?y))
    (What if you were ?y ?) (Do you thin you were ?y)
    (What would it mean if you were ?y))
   (((?* ?x) I am (?* ?y))       
    (In what way are you ?y) (Do you want to be ?y ?))
   (((?* ?x) am I (?* ?y))
    (Do you believe you are ?y) (Would you want to be ?y)
    (Don't ask me I am just a shepherd)
    (What would it mean if you were ?y))
   (((?* ?x) am (?* ?y))
    (Why do you say "AM?") (I don't understand that repugnant shit))
   (((?* ?x) are you (?* ?y))
    (Why are you interested in whether I am ?y or not? That ain't none of your bussiness motherfucker.)
    (Would you prefer if I weren't ?y)
    (Perhaps I am ?y in your fantasies))
   (((?* ?x) you are (?* ?y))   
    (What the hell  makes you think I am ?y ?))

   (((?* ?x) because (?* ?y))
    (Is that the real reason?) (better pick another reason motherfucker?)
    (Does that reason seem to explain anything else?))
   (((?* ?x) were you (?* ?y))
    (Perhaps I was ?y) (What do you think?) (What if I had been ?y))
   (((?* ?x) I can't (?* ?y))    
    (Maybe you could ?y now) (What if you could ?y ?))
   (((?* ?x) I feel (?* ?y))     
    (I don't care about your feelings))
   (((?* ?x) I felt (?* ?y))     
    (Have you felt ?y before?))
   (((?* ?x) I (?* ?y) you (?* ?z))   
    (Perhaps in your fantasy we ?y each other))
   (((?* ?x) why don't you (?* ?y))
    (Should you ?y yourself?)
    (Do you believe I don't ?y) (Perhaps I will ?y in good time))
   (((?* ?x) yes (?* ?y))
    (You seem quite positive) (You are sure) (I understand))
   (((?* ?x) no (?* ?y))
    (Why not?) (You are being a bit negative)
    (Are you saying "NO" just to be negative?))

   (((?* ?x) someone (?* ?y))
    (Man fuck someone that ain't relevant))
   (((?* ?x) everyone (?* ?y))
    (surely not everyone) (Can you think of anyone specifically?)
    (Who for example?))
   (((?* ?x) always (?* ?y))
    (Can you think of a specific example) (When?)
    (What are you thinking of?) (Really-- always))
   (((?* ?x) what (?* ?y))
    (Why do you ask?) (Does that question interest you?)
    (What is it you really want to know?) (What do you think?)
    (What comes to your mind when you ask that?))
   (((?* ?x) perhaps (?* ?y))    
    (You do not seem very sure))
   (((?* ?x) are (?* ?y))
    (Did you think they might not be ?y)
    (Possibly they are ?y))
   (((?* ?x))(no-result))
   ))

;;; ==============================

;;; Testing Harness ----------------

(princ "In order to have a conversation with Jules yourself please enter (jules) into the terminal")
(terpri)
(princ "JULES> hello")
(terpri)
(princ "SUP MOTHERFUCKER?")
(terpri) 
(princ "JULES> what?")
(terpri)
(princ "WHAT DO YOU MEAN WHAT?")
(terpri) 
(princ "JULES> what?")
(terpri)
(princ "SAY WHAT AGAIN. SAY WHAT AGAIN I DARE YOU. I DOUBLE DARE YOU MOTHERFUCKER -  SAY WHAT ONE MORE GODDAMN TIME!") 
(terpri)
(princ "JULES> okay! I'm sorry!")
(terpri)
(princ "APOLOGIES ARE NOT NECESSARY") 
(terpri)
(princ "JULES> well okay then")
(terpri)
(princ "DO I LOOK LIKE A BITCH? DO I LOOK LIKE A BITCH!? THEN WHY YOU TRYING TO FUCK ME LIKE A BITCH?") 
(terpri)
(princ "JULES> you are agressive")
(terpri)
(princ "BE CAREFUL WHAT YOU SAY.") 
(terpri)
(princ "JULES> no")
(terpri)
(princ "ARE YOU SAYING NO JUST TO BE NEGATIVE?") 
(terpri)
(princ "JULES> yes")
(terpri)
(princ "YOU ARE SURE") 
(terpri)
(princ "JULES> no")
(terpri)
(princ "WHY NOT?" )
(terpri)
(princ "JULES> fuck you")
(terpri)
(princ "WATCH YOURSELF MOTHERFUCKER.") 
(terpri)
(princ "JULES> watch yourself")
(terpri)
(princ "DO YOU REMEMBER WHEN YOU SAID \" FUCK YOU \" TO ME EARLIER? THAT WAS SOME FUCKED UP REPUGNANT ASSED SHIT.")
(terpri)

