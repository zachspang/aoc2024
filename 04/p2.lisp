(require "asdf")
(defVar wordSearch (uiop:read-file-lines #P"./input.txt"))

;Check a direction for MAS. iDir and jDir are the direction of the M in relation to A. Either +1 -1. Returns 1 if found
(defun checkForWord (i j iDir jDir inputList horizontalLength verticalLength)
    ;If MAS will go out of bounds
    (if (OR (OR (> (+ i 1) horizontalLength) (< (- i 1) 0)) (OR (> (+ j 1) verticalLength) (< (- j 1) 0)))
        (return-from checkForWord 0)
    )
    (if (CHAR= #\M (char (nth (+ j jDir) inputList) (+ i iDir)))
        (progn        
            (setq iDir (* iDir -1))
            (setq jDir (* jDir -1))  
            (if (CHAR= #\S (char (nth (+ j jDir) inputList) (+ i iDir)))   
                (return-from checkForWord 1) 
            )
        )
    )
    (return-from checkForWord 0)
)

(defVar horizontalLength (- (length (car wordSearch)) 1))
(defVar verticalLength (- (length wordSearch) 1))
(defVar total 0)
;# of MAS crosses going through this A
(defVar currATotal 0)
(loop for i from 0 to horizontalLength
    do (loop for j from 0 to verticalLength
        do (if (CHAR= #\A (char (nth j wordSearch) i))
            (progn
                (setq currATotal 0)
                ;Check all 4 diagnals around A for 2 MAS crossing it 
                (loop for iDir from -1 to 1
                    do (loop for jDir from -1 to 1
                        do(if (AND (/= iDir 0) (/= jDir 0))
                                (setq currATotal (+ currATotal (checkForWord i j iDir jDir wordSearch horizontalLength verticalLength)))
                        )
                    )
                )
                (if (= currATotal 2)
                    (setq total (+ total 1))
                )
            )
        )
    )
)

(print total)