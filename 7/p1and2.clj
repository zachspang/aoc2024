
(ns aoc
  (:require 
    [clojure.string :as str]
    [clojure.math.combinatorics :as combo]))

;Concatenate left and right numbers
(defn concatenation [left right]
    (read-string (str left right))
)

;Loop through every combonation of operators and perform them in order
(defn checkIfValid? [testValue equation operatorList](
    let [result (atom false)] 
    (do
        (doseq [operators (combo/selections operatorList (- (count equation) 1))]
            (let [sum (atom (read-string (get equation 0)))]
                (dotimes [i (count operators)] 
                    (reset! sum ((nth operators i) (deref sum) (read-string (get equation (+ i 1)))))
                )
                (if (= (deref sum) (read-string testValue)) (reset! result true))
            )
        )
        (deref result)
    )
))

(def input (str/split-lines (slurp "input.txt")))
(def p1Total 0)
(def p2Total 0)

;For each line check if it possible to make the testValue
(doseq [line input]
    (def splitLine (str/split line #": "))
    (def testValue (get splitLine 0))
    (def equation (str/split (get splitLine 1) #" "))
    
    ;If checkIfValid is true add testValue to total
    (if (checkIfValid? testValue equation [+ *])
        (def p1Total (+ p1Total (read-string testValue)))
    )
    (if (checkIfValid? testValue equation [+ * concatenation])
        (def p2Total (+ p2Total (read-string testValue)))
    )
)

(println p1Total)
(println p2Total)