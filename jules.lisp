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
  (if (> (length input) 1)
      (cond
       ((and (equal (first input) 'don)
	     (equal (second input) (quote 't)))
	(append '(do not) (quote-replace (cdr (cdr input)))))

       ((and (equal (first input) 'didn)
	     (equal (second input) (quote 't)))
	(append '(do not) (quote-replace (cdr (cdr input)))))
       
       ((and (equal (first input) 'doesn)
	     (equal (second input) (quote 't)))
	(append '(does not) (quote-replace (cdr (cdr input)))))
       
       ((and (equal (first input) 'hadn)
	     (equal (second input) (quote 't)))
	(append '(had not) (quote-replace (cdr (cdr input)))))
       
       ((and (equal (first input) 'hasn)
	     (equal (second input) (quote 't)))
	   (append '(has not) (quote-replace (cdr (cdr input)))))

       ((and (equal (first input) 'isn)
	     (equal (second input) (quote 't)))
	   (append '(is not) (quote-replace (cdr (cdr input)))))

       ((and (equal (first input) 'haven)
	     (equal (second input) (quote 't)))
	   (append '(have not) (quote-replace (cdr (cdr input)))))

       ((and (equal (first input) 'aren)
	     (equal (second input) (quote 't)))
	   (append '(are not) (quote-replace (cdr (cdr input)))))

       ((and (equal (first input) 'let)
	     (equal (second input) (quote 's)))
	   (append '(let us) (quote-replace (cdr (cdr input)))))

       ((and (equal (first input) 'shouldn)
	     (equal (second input) (quote 't)))
	   (append '(should not) (quote-replace (cdr (cdr input)))))

       ((and (equal (first input) 'couldn)
	     (equal (second input) (quote 't)))
	   (append '(could not) (quote-replace (cdr (cdr input)))))

       ((and (equal (first input) 'wouldn)
	     (equal (second input) (quote 't)))
	   (append '(would not) (quote-replace (cdr (cdr input)))))

       ((and (equal (first input) 'mightn)
	     (equal (second input) (quote 't)))
	   (append '(might not) (quote-replace (cdr (cdr input)))))

       ((and (equal (first input) 'mustn)
	     (equal (second input) (quote 't)))
	   (append '(must not) (quote-replace (cdr (cdr input)))))

       ((and (equal (first input) 'weren)
	     (equal (second input) (quote 't)))
	   (append '(were not) (quote-replace (cdr (cdr input)))))

       ((and (equal (first input) 'can)
	     (equal (second input) (quote 't)))
	   (append '(can not) (quote-replace (cdr (cdr input)))))

       ((and (equal (first input) 'won)
	     (equal (second input) (quote 't)))
	   (append '(will not) (quote-replace (cdr (cdr input)))))

       ((and (equal (first input) 'wish)
	     (equal (second input) 'for))
	   (cons 'want (quote-replace (cdr (cdr input)))))

       ((and (equal (first input) 'hope)
	     (equal (second input) 'for))
	   (cons 'want (quote-replace (cdr (cdr input)))))

       ((and (equal (first input) 'aspire)
	     (equal (second input) 'to))
	   (cons 'want (quote-replace (cdr (cdr input)))))

       ((and (equal (first input) 'used)
	     (equal (second input) 'to)
	     (equal (second input) 'be))
	(cons 'was (quote-replace (cdr (cdr input)))))

       ((and (equal (first input) 'i)
	     (equal (second input) (quote 'm)))
	   (append '(i am) (quote-replace (cdr (cdr input)))))

       ((and (equal (first input) 'isn)
	     (equal (second input) (quote 't)))
	   (append '(is not) (quote-replace (cdr (cdr input)))))

       ((equal (first input) (quote 's))
	(cons 'is (quote-replace (cdr input))))

       ((equal (first input) (quote 'll))
	(cons 'will (quote-replace (cdr input))))

       ((equal (first input) (quote 're))
	(cons 'are (quote-replace (cdr input))))

       ((equal (first input) (quote 've))
	(cons 'have (quote-replace (cdr input))))

       ((equal (first input) (quote 'em))
	(cons 'them (quote-replace (cdr input))))

       ((equal (first input) (quote 'd))
	(cons 'did (quote-replace (cdr input))))

       (T (cons (first input) (quote-replace (cdr input)))))

    input)
  )

(defun synonym-replace (input)
  (sublis '(
	    (hi . hello)
	    (hola . hello)
	    (yo . hello)
	    (hey . hello)
	    (howdy . hello)
	    (aloha . hello)
	    (nope . no)
	    (yeah . yes)
	    (yep . yes)
	    (nah . no)
	    (naw . no)
	    (similar . alike)
	    (identical . same)
	    (equal . same)
	    (somebody . someone)
	    (everbody . everyone)
	    (maybe . perhaps)
	    (consistently . always)
	    (fantasize . dream)
	    (fantasized . dreamt)
	    (imagine . dream)
	    (imagined . dreamt)
	    (apologize . sorry)
	    (recall . remember)
	    (recollect . remember)
	    (muse . dream)
	    (mused . dreamt)
	    (daydream . dream)
	    (daydreamed . dreamt)
	    (mom . mother)
	    (mama . mother)
	    (ma . mother)
	    (mommy . mother)
	    (dad . father)
	    (daddy . father)
	    (dada . father)
	    (papa . father)
	    (desire . want)
	    (lust . want)
	    (happy . glad)
	    (pleased . glad)
	    (delighted . glad)
	    (overjoyed . glad)
	    (thrilled . glad)
	    (elated . glad)
	    (unhappy . sad)
	    (miserable . sad)
	    (depressed . sad)
	    (gloomy . sad)
	    (sorrowful . sad)
	    (dejected . sad)
	    (glum . sad)
	    (since . because)
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
      ;(princ input)(terpri)
      ;(princ fixed-input)(terpri)
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
   (((?* ?x) food (?* ?y))
    (Speaking of food have you ever had a royal with cheese? That is a tasty burger!))
   (((?* ?x) advice)
    (What I try to do myself is always maintain an air of cool.))
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
    (I do not care about dreams motherfucker.))
   (((?* ?x) my mother (?* ?y))
    (Keep family out of this.))
   (((?* ?x) my father (?* ?y))
    (Your father?)(Keep family out of this.)(At least you had a father growing up) 
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
    (Do not ask me that I am just a shepherd)
    (What would it mean if you were ?y))
   (((?* ?x) am (?* ?y))
    (Why do you say "AM?") (I do not understand that repugnant shit))
   (((?* ?x) are you (?* ?y))
    (Why are you interested in whether I am ?y or not? That is none of your bussiness motherfucker.)
    (Would you prefer if I were not ?y)
    (Perhaps I am ?y in your fantasies))
   (((?* ?x) you are (?* ?y))   
    (What the hell  makes you think I am ?y ?))

   (((?* ?x) because (?* ?y))
    (Is that the real reason?) (better pick another reason motherfucker)
    (Does that reason seem to explain anything else to you bitch?))
   (((?* ?x) were you (?* ?y))
    (Perhaps I was ?y) (What do you think?) (What if I had been ?y))
   (((?* ?x) I can not (?* ?y))    
    (Yes you fucking can ?y) (What if you could ?y ?))
   (((?* ?x) I feel (?* ?y))     
    (I do not care about your feelings))
   (((?* ?x) I felt (?* ?y))     
    (Have you felt ?y before?  Not that I give a damn))
   (((?* ?x) I (?* ?y) you (?* ?z))   
    (Maybe in your dreams we ?y each other but not in this world))
   (((?* ?x) why do not you (?* ?y))
    (Should you ?y yourself?)
    (Do you believe I do not ?y) (Lord have mercy I will never ?y))
   (((?* ?x) yes (?* ?y))
    (You seem pretty fucking positive) (You are sure) (You better be damn sure))
   (((?* ?x) no (?* ?y))
    (Why not motherfucker?) (You are being a bit negative)
    (Are you saying "NO" just to be negative?))

   (((?* ?x) someone (?* ?y))
    (Man fuck someone that is not relevant))
   (((?* ?x) everyone (?* ?y))
    (Surely not everyone) (Can you think of anyone specifically?)
    (Who for example?  What did they look like?))
   (((?* ?x) always (?* ?y))
    (Can you think of a specific example) (When?)
    (What are you thinking of?) (Really-- always?))
   (((?* ?x) what (?* ?y))
    (Why do you ask?) (Does that question interest you?)
    (What is it you really want to know?) (What do you think?)
    (Do you really want to know that?))
   (((?* ?x) perhaps (?* ?y))    
    (You do not seem too certain about that))
   (((?* ?x) are (?* ?y))
    (Did you think they might not be ?y)
    (Possibly they are ?y))
   (((?* ?x))(no-result))
   ))

;;; ==============================

;;; Testing Harness ----------------
(princ "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
(terpri)
(princ "Demonstrating a conversation with Jules Winnfield...")
(terpri)
(princ "In order to have a conversation with Jules yourself please enter (jules) into the terminal")
(terpri)
(princ "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
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

(princ "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
(terpri)
(princ "Demonstrating another conversation with Jules Winnfield...")
(terpri)
(princ "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
(terpri)
(princ "JULES> hello")
(terpri)
(princ "SUP MOTHERFUCKER?")
(terpri) 
(princ "JULES> how are you?")
(terpri)
(princ "WHY ARE YOU INTERESTED IN WHETHER I AM OR NOT? THAT IS NONE OF YOUR BUSSINESS MOTHERFUCKER.")
(terpri) 
(princ "JULES> you are agressive")
(terpri)
(princ "YOU SON OF A BITCH!") 
(terpri)
(princ "JULES> do you have any advice for me?")
(terpri)
(princ "ENGLISH MOTHERFUCKER - DO YOU SPEAK IT? ") 
(terpri)
(princ "JULES> So no advice?")
(terpri)
(princ "WHAT I TRY TO DO MYSELF IS ALWAYS MAINTAIN AN AIR OF COOL.") 
(terpri)
(princ "JULES> that's not true")
(terpri)
(princ "BE CAREFUL WHAT YOU SAY.") 
(terpri)
(princ "JULES> you make no sense")
(terpri)
(princ "YOU ARE BEING A BIT NEGATIVE")
(terpri)
(princ "JULES> you are being a bastard")
(terpri)
(princ "YOU SON OF A BITCH!")
(terpri)
(princ "JULES> I am hungry")
(terpri)
(princ "DO YOU WANT TO BE HUNGRY ?")
(terpri)
(princ "JULES> No I need food")
(terpri)
(princ "SPEAKING OF FOOD HAVE YOU EVER HAD A ROYAL WITH CHEESE? THAT IS A TASTY BURGER!")
(terpri)
(princ "JULES> nope I haven't")
(terpri)
(princ "YOU ARE BEING A BIT NEGATIVE") 
(terpri)
(princ "JULES> Just telling the truth")
(terpri)
(princ "DO I LOOK LIKE A BITCH? DO I LOOK LIKE A BITCH!? THEN WHY YOU TRYING TO FUCK ME LIKE A BITCH?") 
(terpri)
(princ "JULES> fuck you")
(terpri)
(princ "WATCH YOURSELF MOTHERFUCKER.")
(terpri)
(princ "JULES> okay")
(terpri)
(princ "DO YOU REMEMBER WHEN YOU SAID \" I AM NOT \" TO ME EARLIER? CAN YOU CONTINUE WITH THAT THOUGHT?") 
(terpri)
(princ "JULES> no i won't")
(terpri)
(princ "YOU ARE BEING A BIT NEGATIVE") 
(terpri)
(princ "JULES> fuck you")
(terpri)
(princ "TAKE THAT BACK.")
(terpri)
(princ "JULES> no")
(terpri)
(princ "WHY NOT MOTHERFUCKER?") 
(terpri)
(princ "JULES> because you are a jerk")
(terpri)
(princ "WHAT THE HELL MAKES YOU THINK I AM A JERK ?")
(terpri)
(princ "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
(terpri)
(princ "Demonstrating another conversation with Jules Winnfield...")
(terpri)
(princ "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
(terpri)(terpri)
(princ "JULES> hello")(terpri)
(princ "SUP MOTHERFUCKER?")(terpri) 
(princ "JULES> good")(terpri)
(princ "DO I LOOK LIKE A BITCH? DO I LOOK LIKE A BITCH!? THEN WHY YOU TRYING TO FUCK ME LIKE A BITCH?")(terpri)
(princ "JULES> no you do not")(terpri)
(princ "ARE YOU SAYING NO JUST TO BE NEGATIVE?")(terpri)
(princ "JULES> yes")(terpri)
(princ "YOU ARE SURE")(terpri) 
(princ "JULES> yes")(terpri)
(princ "YOU BETTER BE DAMN SURE")(terpri) 
(princ "JULES> I am damn sure")(terpri)
(princ "IN WHAT WAY ARE YOU DAMN SURE")(terpri) 
(princ "JULES> sure that I don't want to die")(terpri)
(princ "ENGLISH MOTHERFUCKER - DO YOU SPEAK IT?")(terpri) 
(princ "JULES> yes")(terpri)
(princ "YOU SEEM PRETTY FUCKING POSITIVE")(terpri) 
(princ "JULES> I am positive")(terpri)
(princ "IN WHAT WAY ARE YOU POSITIVE")(terpri) 
(princ "JULES> just don't kill me")(terpri)
(princ "DO YOU REMEMBER WHEN YOU SAID \" YES \" TO ME EARLIER? CAN YOU CONTINUE WITH THAT THOUGHT?")(terpri)
(princ "JULES> no")(terpri)
(princ "YOU ARE BEING A BIT NEGATIVE")(terpri)
(princ "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~") 
