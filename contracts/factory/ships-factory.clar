(define-constant ERR-NOT-AUTHORIZED (err u401))

(define-data-var contract-owner principal tx-sender)
(define-data-var common-trait-value uint u2)
(define-data-var rare-trait-value uint u3)

;; A map that creates a id => rle string relation.
;; body 
(define-map common-body-trait uint (string-utf8 20000))
(define-data-var last-common-body-id uint u0)
(define-map rare-body-trait uint (string-utf8 20000))
(define-data-var last-rare-body-id uint u0)
;; mast
(define-map common-mast-trait uint (string-utf8 20000))
(define-data-var last-common-mast-id uint u0)
(define-map rare-mast-trait uint (string-utf8 20000))
(define-data-var last-rare-mast-id uint u0)
;; telescope
(define-map common-telescope-trait uint (string-utf8 20000))
(define-data-var last-common-telescope-id uint u0)
(define-map rare-telescope-trait uint (string-utf8 20000))
(define-data-var last-rare-telescope-id uint u0)
;; sail
(define-map common-sail-trait uint (string-utf8 20000))
(define-data-var last-common-sail-id uint u0)
(define-map rare-sail-trait uint (string-utf8 20000))
(define-data-var last-rare-sail-id uint u0)
;; anchor
(define-map common-anchor-trait uint (string-utf8 20000))
(define-data-var last-common-anchor-id uint u0)
(define-map rare-anchor-trait uint (string-utf8 20000))
(define-data-var last-rare-anchor-id uint u0)
;; window
(define-map common-window-trait uint (string-utf8 20000))
(define-data-var last-common-window-id uint u0)
(define-map rare-window-trait uint (string-utf8 20000))
(define-data-var last-rare-window-id uint u0)

;; addition:common-trait
(define-public (add-common-mast-trait (trait-rle (string-utf8 20000))) 
    (begin 
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        (map-set common-mast-trait (var-get last-common-mast-id) trait-rle)
        (var-set last-common-mast-id (+ (var-get last-common-mast-id) u1))
        (ok true)
    )
)
(define-public (add-common-telescope-trait (trait-rle (string-utf8 20000))) 
    (begin 
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        (map-set common-telescope-trait (var-get last-common-telescope-id) trait-rle)
        (var-set last-common-telescope-id (+ (var-get last-common-telescope-id) u1))
        (ok true)
    )
)
(define-public (add-common-sail-trait (trait-rle (string-utf8 20000))) 
    (begin 
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        (map-set common-sail-trait (var-get last-common-sail-id) trait-rle)
        (var-set last-common-sail-id (+ (var-get last-common-sail-id) u1))
        (ok true)
    )
)
(define-public (add-common-body-trait (trait-rle (string-utf8 20000))) 
    (begin 
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        (map-set common-body-trait (var-get last-common-body-id) trait-rle)
        (var-set last-common-body-id (+ (var-get last-common-body-id) u1))
        (ok true)
    )
)
(define-public (add-common-window-trait (trait-rle (string-utf8 20000))) 
    (begin 
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        (map-set common-window-trait (var-get last-common-window-id) trait-rle)
        (var-set last-common-window-id (+ (var-get last-common-window-id) u1))
        (ok true)
    )

)
(define-public (add-common-anchor-trait (trait-rle (string-utf8 20000))) 
    (begin 
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        (map-set common-anchor-trait (var-get last-common-anchor-id) trait-rle)
        (var-set last-common-anchor-id (+ (var-get last-common-anchor-id) u1))
        (ok true)
    )
)

;; addition:rare-trait
(define-public (add-rare-mast-trait (trait-rle (string-utf8 20000))) 
    (begin 
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        (map-set rare-mast-trait (var-get last-rare-mast-id) trait-rle)
        (var-set last-rare-mast-id (+ (var-get last-rare-mast-id) u1))
        (ok true)
    )
)
(define-public (add-rare-telescope-trait (trait-rle (string-utf8 20000))) 
    (begin 
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        (map-set rare-telescope-trait (var-get last-rare-telescope-id) trait-rle)
        (var-set last-rare-telescope-id (+ (var-get last-rare-telescope-id) u1))
        (ok true)
    )
)
(define-public (add-rare-sail-trait (trait-rle (string-utf8 20000))) 
    (begin 
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        (map-set rare-sail-trait (var-get last-rare-sail-id) trait-rle)
        (var-set last-rare-sail-id (+ (var-get last-rare-sail-id) u1))
        (ok true)
    )
)
(define-public (add-rare-body-trait (trait-rle (string-utf8 20000))) 
    (begin 
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        (map-set rare-body-trait (var-get last-rare-body-id) trait-rle)
        (var-set last-rare-body-id (+ (var-get last-rare-body-id) u1))
        (ok true)
    )
)
(define-public (add-rare-window-trait (trait-rle (string-utf8 20000))) 
    (begin 
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        (map-set rare-window-trait (var-get last-rare-window-id) trait-rle)
        (var-set last-rare-window-id (+ (var-get last-rare-window-id) u1))
        (ok true)
    )

)
(define-public (add-rare-anchor-trait (trait-rle (string-utf8 20000))) 
    (begin 
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        (map-set rare-anchor-trait (var-get last-rare-anchor-id) trait-rle)
        (var-set last-rare-anchor-id (+ (var-get last-rare-anchor-id) u1))
        (ok true)
    )
)

;; get:common-traits by index
(define-read-only (get-common-mast-trait-idx (idx uint)) 
    (map-get? common-mast-trait idx)
)
(define-read-only (get-common-telescope-trait-idx (idx uint)) 
    (map-get? common-telescope-trait idx)
)
(define-read-only (get-common-sail-trait-idx (idx uint)) 
    (map-get? common-sail-trait idx)
)
(define-read-only (get-common-body-trait-idx (idx uint)) 
    (map-get? common-body-trait idx)
)
(define-read-only (get-common-window-trait-idx (idx uint)) 
    (map-get? common-window-trait idx)
)
(define-read-only (get-common-anchor-trait-idx (idx uint)) 
    (map-get? common-anchor-trait idx)
)

;; get:rare-traits by index
(define-read-only (get-rare-mast-trait-idx (idx uint)) 
    (map-get? rare-mast-trait idx)
)
(define-read-only (get-rare-telescope-trait-idx (idx uint)) 
    (map-get? rare-telescope-trait idx)
)
(define-read-only (get-rare-sail-trait-idx (idx uint)) 
    (map-get? rare-sail-trait idx)
)
(define-read-only (get-rare-body-trait-idx (idx uint)) 
    (map-get? rare-body-trait idx)
)
(define-read-only (get-rare-window-trait-idx (idx uint)) 
    (map-get? rare-window-trait idx)
)
(define-read-only (get-rare-anchor-trait-idx (idx uint)) 
    (map-get? rare-anchor-trait idx)
)


;; select random traits for minting
(define-private (get-random (max uint))
    (unwrap-panic 
        (contract-call? .random-number get-random max u489420000)
    )
)

(define-private (select-from-common (trait-type (string-ascii 3)))
   ;; for mast
    (if (is-eq trait-type "Mas")
        (get-random (var-get last-common-mast-id))
        ;; for telescope 
        (if (is-eq trait-type "Tel")
            (get-random (var-get last-common-telescope-id))
            ;; for sail 
            (if (is-eq trait-type "Sai")
                (get-random (var-get last-common-sail-id))
                ;; for body 
                (if (is-eq trait-type "Bod")
                    (get-random (var-get last-common-body-id))
                    ;; for window 
                    (if (is-eq trait-type "Win")
                        (get-random (var-get last-common-window-id))
                        ;; for anchor 
                        (if (is-eq trait-type "Anc")
                             (get-random (var-get last-common-anchor-id))
                            ;; solve this, have to return err saying no trait found with given trait type
                             (get-random (var-get last-common-anchor-id))
                        )
                    )
                )
            )
        )
    )  
)

(define-private (select-from-rare (trait-type (string-ascii 3)))
   ;; for mast
    (if (is-eq trait-type "Mas")
        (get-random (var-get last-rare-mast-id))
        ;; for telescope 
        (if (is-eq trait-type "Tel")
            (get-random (var-get last-rare-telescope-id))
            ;; for sail 
            (if (is-eq trait-type "Sai")
                 (get-random (var-get last-rare-sail-id))
                ;; for body 
                (if (is-eq trait-type "Bod")
                    (get-random (var-get last-rare-body-id))
                    ;; for window 
                    (if (is-eq trait-type "Win")
                        (get-random (var-get last-rare-window-id))
                        ;; for anchor 
                        (if (is-eq trait-type "Anc")
                            (get-random (var-get last-rare-anchor-id))
                            ;; solve this, have to return err saying no trait found with given trait type
                            (get-random (var-get last-rare-anchor-id))
                        )
                    )
                )
            )
        )
    )  
)

(define-private (select-random-trait (trait-type (string-ascii 3))) 
    (let
        (
            (chance-random (contract-call? .random-number get-random u89 u328)) 
        )
        ;; (if (> (+ chance-random (contract-call? .game get-user-buffer tx-sender) u90) 
        (if (> u89 u90) 
            (begin
                ;; if 1 then choose from rare else from common
                (if (is-eq (unwrap-panic (contract-call? .random-number get-random u2 u328)) u1)
                    (ok { is-rare : true , is-rare-val : (var-get rare-trait-value), trait-idx : (select-from-rare trait-type)})
                    (ok { is-rare : false , is-rare-val : (var-get common-trait-value), trait-idx : (select-from-common trait-type)})   
                )
            )
            ;; always common
            (ok { is-rare : false , is-rare-val : (var-get common-trait-value), trait-idx : (select-from-common trait-type)})   

        )
	)
)

(define-public (get-random-traits)
    (let
        (
            (body-obj (unwrap-panic (select-random-trait "Bod"))) 
            (mast-obj (unwrap-panic (select-random-trait "Mas")))
            (telescope-obj (unwrap-panic (select-random-trait "Tel"))) 
            (window-obj (unwrap-panic (select-random-trait "Win")))
            (anchor-obj (unwrap-panic (select-random-trait "Anc"))) 
            (sail-obj (unwrap-panic (select-random-trait "Sai")))
            (is-rare-val (fold + (list (get is-rare-val body-obj) (get is-rare-val mast-obj) (get is-rare-val telescope-obj) (get is-rare-val window-obj) (get is-rare-val anchor-obj) (get is-rare-val sail-obj)) u0))
            (is-rare (if (>= is-rare-val u16) true false))
        )
        (ok {
            traits: {  
                body : {idx : (get trait-idx body-obj), is-rare : (get is-rare body-obj)},
                mast : {idx : (get trait-idx mast-obj), is-rare : (get is-rare mast-obj)},
                telescope : {idx : (get trait-idx telescope-obj), is-rare : (get is-rare telescope-obj)},
                window : {idx : (get trait-idx window-obj), is-rare : (get is-rare window-obj)},
                anchor : {idx : (get trait-idx anchor-obj), is-rare : (get is-rare anchor-obj)},
                sail : {idx : (get trait-idx sail-obj), is-rare : (get is-rare sail-obj)}
            },
            is-rare: is-rare,
            tov: (* (+ u4 (mod is-rare-val u15)) u3600);; [4-18] hours (in secs)
         }
        )
    )
)

(define-public (get-traits-rle (traits { body: { idx : uint, is-rare : bool }, mast : {idx : uint, is-rare : bool} , telescope : { idx : uint , is-rare : bool} , window : {idx : uint, is-rare : bool}, anchor : {idx : uint, is-rare : bool}, sail : {idx : uint, is-rare : bool}})) 
    (ok
        { 
            body :  (if (get is-rare (get body traits)) (get-rare-body-trait-idx (get idx (get body traits))) (get-common-body-trait-idx (get idx (get body traits)))),
            mast : (if (get is-rare (get mast traits)) (get-rare-mast-trait-idx (get idx (get mast traits))) (get-common-mast-trait-idx (get idx (get mast traits)))),
            telescope : (if (get is-rare (get telescope traits)) (get-rare-telescope-trait-idx (get idx (get telescope traits))) (get-common-telescope-trait-idx (get idx (get telescope traits)))),
            window : (if (get is-rare (get window traits)) (get-rare-window-trait-idx (get idx (get window traits))) (get-common-window-trait-idx (get idx (get window traits)))),
            anchor : (if (get is-rare (get anchor traits)) (get-rare-anchor-trait-idx (get idx (get anchor traits))) (get-common-anchor-trait-idx (get idx (get anchor traits)))),
            sail : (if (get is-rare (get sail traits)) (get-rare-sail-trait-idx (get idx (get sail traits))) (get-common-sail-trait-idx (get idx (get sail traits))))
        }
    )
)



