(require "asdf")
(defVar wordSearch (uiop:read-file-lines #P"./input.txt"))

;Check a direction for XMAS. iDir and jDir are the direction to move i and j. Either +1 -1 or 0. Returns 1 if found
(defun checkForWord (i j iDir jDir inputList horizontalLength verticalLength)
    (setq i (+ i iDir))
    (setq j (+ j jDir))

    ;If xmas will go out of bounds
    (if (OR (OR (> (+ i (+ iDir iDir)) horizontalLength) (< (+ i (+ iDir iDir)) 0)) (OR (> (+ j (+ jDir jDir)) verticalLength) (< (+ j (+ jDir jDir)) 0)))
        (return-from checkForWord 0)
    )
    (if (CHAR= #\M (char (nth j inputList) i))
        (progn
            (setq i (+ i iDir))
            (setq j (+ j jDir))   
            (if (CHAR= #\A (char (nth j inputList) i))
                (progn
                    (setq i (+ i iDir))
                    (setq j (+ j jDir))
                    (if (CHAR= #\S (char (nth j inputList) i))
                        (return-from checkForWord 1)
                    )
                )
            )
        )
    )
    (return-from checkForWord 0)
)

(defVar horizontalLength (- (length (car wordSearch)) 1))
(defVar verticalLength (- (length wordSearch) 1))
(defVar total 0)

(loop for i from 0 to horizontalLength
    do (loop for j from 0 to verticalLength
        do (if (CHAR= #\X (char (nth j wordSearch) i))
            ;Check all 8 directions around X for MAS
            (loop for iDir from -1 to 1
                do (loop for jDir from -1 to 1
                    do(if (OR (/= iDir 0) (/= jDir 0))
                            (setq total (+ total (checkForWord i j iDir jDir wordSearch horizontalLength verticalLength)))
                    )
                )
            )
        )
    )
)

(print total)