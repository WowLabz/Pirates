(define-constant user-not-found (err u404))

(define-map user-to-trs principal uint)
(define-map id-user uint principal)
(define-data-var total-user uint u0)


(define-public (add-trs-value (val uint) (address principal)) 
     ;;TODO: ONLY APPROVED CONTRACT CAN CALL THIS FUNCTION
    (match (map-get? user-to-trs address)
        prev-val (begin 
            (map-set user-to-trs address (+ val prev-val)) 
            (ok true)
        )
        (begin
            (map-set user-to-trs address val)
            (map-set id-user (var-get total-user) tx-sender)
            (var-set total-user (+ (var-get total-user) u1))
            (ok true)
        )
    )        
    
)

(define-read-only (get-trs-value (address principal)) 
   (map-get? user-to-trs address)
)

(define-read-only (get-total-user) 
    (var-get total-user)
)

(define-read-only (get-trs-val-from-id (id uint))
    (begin 
        (asserts! (< id (var-get total-user)) user-not-found)
        (ok { address : (unwrap-panic (map-get? id-user id)), trs-token : (unwrap-panic (get-trs-value (default-to tx-sender (map-get? id-user id))))})
    )
)
