.ORIG x3000               ; Begin the program

; Define constants for letter grades
A           .FILL x3100
B           .FILL x3101
C           .FILL x3102
D           .FILL x3103
F           .FILL x3104

; Define variables
SCORES      .fill x0000       ; Memory location for test scores (5 two-digit scores)
            .fill x0000
            .fill x0000
            .fill x0000
            .fill x0000
MIN_SCORE   .FILL x0064   ; Initial value set to 100 to decrement and find minimum
MAX_SCORE   .FILL x0000   ; Initial value set to 0 to increment and find maximum
SUM         .FILL x0000   ; Initial value set to 0 to add up scores
COUNT       .FILL x0000   ; Initial value set to 0 to increment number of test scores entered
AVERAGE     .FILL x0000  ; Memory location for average score


; Subroutine to prompt the user to input test scores
PROMPT      LEA R0, PROMPTs ; Prompt user to enter test scores
            PUTS           ; Display on console

; Subroutine to read test scores from the user
READ_SCORES LEA R1, SCORES   ; Load scores address to R1
            LD R4, COUNT     ; Load count's value to R4
READ_LOOP   GETC             ; Get input character
            OUT              ; Display the input character
            JSR CONVERT_ASCII_TO_BINARY ; Convert ASCII character to binary

            LDR R7, R1, #0   ; Load value from memory location pointed by R1 into R7
            ADD R7, R7, R0   ; Add converted score to memory location

            STR R7, R1, #0 ; Store the score in memory
            ADD R1, R1, #1 ; Move to next memory location
            ADD R4, R4, #1 ; Increment the count

            LD R0, COUNT        ; Load count value to R0
            ADD R0, R0, #-5  ; Subtract 5 from R0

            BRz CALC_SCORES  ; Branch to CALC_SCORES if count equals 5
            BRnzp READ_LOOP  ; Continue loop if not end of line character is shown
         

CALC_SCORES LEA R1, SCORES   ; Load SCORES address to R1
            LD R2, COUNT     ; Load COUNT value to R2
            LD R3, MIN_SCOREs ; Load to R3
            LD R4, MAX_SCORE ; Load to R4
            LD R5, SUM       ; Load to R5
            ADD R5, R5, #0   ; Reset sum

LOOP_CALC   LDR R6, R1, #0   ; Load score from memory
            ADD R5, R5, R6   ; Add score to sum

            ADD R6, R6, R3   ; Compare score with MIN_SCORE
            BRp SKIP_MIN     ; Branch is positive, score is >= MIN_SCORE)
            STR R6, R3, #0   ; Update MIN_SCORE

SKIP_MIN    ADD R6, R6, R4   ; Compare score with MAX_SCORE
            BRn SKIP_MAX     ; Branch is negative, score is <= MAX_SCORE)
            STR R6, R4, #0   ; Update MAX_SCORE

SKIP_MAX    ADD R1, R1, #1   ; Move to next memory location
            ADD R2, R2, #-1  ; Decrement count

            BRp LOOP_CALC   ; Continue loop if count > 0

            LD R0, SUM       ; Load sum value to R0
            ADD R0, R0, R2   ; Add count to sum
            ADD R0, R0, #-5  ; Subtract 5 from sum (to exclude the end of line characters)
            ADD R0, R0, #0   ; Reset sum
            ADD R0, R0, R2   ; Divide sum by count (R0 now contains average score)
            ST R0, AVERAGE   ; Store average score in memory

            ST R2, COUNT     ; Store the updated count back to memory

            RET

; Subroutine to display the calculated scores
DISPLAY     LEA R0, MIN_SCOREs ; Load MIN_SCOREs label to R0
            PUTS               ; Display "Minimum test score: " on console
            LD R0, MIN_SCORE   ; Load MIN_SCORE value to R0
            OUT                ; Display MIN_SCORE's value

            LEA R0, MAX_SCOREs ; Load MAX_SCOREs label to R0
            PUTS               ; Display "Maximum test score: " on console
            LD R0, MAX_SCORE   ; Load MAX_SCORE value to R0
            OUT                ; Display MAX_SCORE's value

            LEA R0, AVERAGEs   ; Load AVERAGEs label to R0
            PUTS               ; Display "Average test score: " on console
            LD R0, AVERAGE     ; Load AVERAGE value to R0
            OUT                ; Display AVERAGE's value

            RET
; Subroutine to convert ASCII character to binary
; Input: R0 - ASCII character
; Output: R0 - Binary value
CONVERT_ASCII_TO_BINARY
    ADD R3, R0, x0     ; Copy R0 to R3
    NOT R3, R3         ; Negate R3
    ADD R3, R3, #1     ; Add 1 to R3 (to obtain the 2's complement of R0)
    ADD R0, R3, x0     ; Copy R3 to R0
    RET

; Main program starts here
MAIN        JSR PROMPT       ; Prompt the user to enter test scores
            JSR READ_SCORES  ; Read test scores from the user
            JSR CALC_SCORES  ; Calculate minimum, maximum, and average scores
            JSR DISPLAY      ; Display the calculated scores

            HALT             ; Halt the program

PROMPTs     .STRINGZ "Enter test scores: "
MIN_SCOREs  .STRINGZ "Minimum test score: "
MAX_SCOREs  .STRINGZ "Maximum test score: "
AVERAGEs    .STRINGZ "Average test score: "
.END