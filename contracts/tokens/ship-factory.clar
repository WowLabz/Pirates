(define-constant ERR-NOT-AUTHORIZED (err u401))
(define-constant err-getting-random-rle-data (err u402))

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
;; sails
(define-map common-sails-trait uint (string-utf8 20000))
(define-data-var last-common-sails-id uint u0)
(define-map rare-sails-trait uint (string-utf8 20000))
(define-data-var last-rare-sails-id uint u0)
;; anchor
(define-map common-anchor-trait uint (string-utf8 20000))
(define-data-var last-common-anchor-id uint u0)
(define-map rare-anchor-trait uint (string-utf8 20000))
(define-data-var last-rare-anchor-id uint u0)
;; windows
(define-map common-windows-trait uint (string-utf8 20000))
(define-data-var last-common-windows-id uint u0)
(define-map rare-windows-trait uint (string-utf8 20000))
(define-data-var last-rare-windows-id uint u0)

;; function related to body trait of ship
;; handled ship common traits
(define-read-only (get-common-trait-at-index (id uint) (trait-type (string-ascii 3)))
    ;; for mast
    (if (is-eq trait-type "Mas")
        (map-get? common-mast-trait id)
        ;; for telescope 
        (if (is-eq trait-type "Tel")
            (map-get? common-telescope-trait id)
            ;; for sails 
            (if (is-eq trait-type "Sai")
                (map-get? common-sails-trait id)
                ;; for body 
                (if (is-eq trait-type "Bod")
                    (map-get? common-body-trait id)
                    ;; for windows 
                    (if (is-eq trait-type "Win")
                        (map-get? common-windows-trait id)
                        ;; for anchor 
                        (if (is-eq trait-type "Anc")
                            (map-get? common-anchor-trait id)
                            none
                        )
                    )
                )
            )
        )
    )        
)

(define-public (add-common-trait (trait-rle (string-utf8 20000)) (trait-type (string-ascii 3)))
    (begin
		(asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        ;; for mast 
        (if (is-eq trait-type "Mas")
            (begin 
                (map-set common-mast-trait (var-get last-common-mast-id) trait-rle)
                (var-set last-common-mast-id (+ (var-get last-common-mast-id) u1))
            )
            ;; for telescope 
            (if (is-eq trait-type "Tel")
                (begin 
                    (map-set common-telescope-trait (var-get last-common-telescope-id) trait-rle)
                    (var-set last-common-telescope-id (+ (var-get last-common-telescope-id) u1))
                )
                ;; for sails 
                (if (is-eq trait-type "Sai")
                    (begin 
                        (map-set common-sails-trait (var-get last-common-sails-id) trait-rle)
                        (var-set last-common-sails-id (+ (var-get last-common-sails-id) u1))
                    )
                    ;; for body
                    (if (is-eq trait-type "Bod")
                        (begin 
                            (map-set common-body-trait (var-get last-common-body-id) trait-rle)
                            (var-set last-common-body-id (+ (var-get last-common-body-id) u1))
                        )
                        ;; for windows 
                        (if (is-eq trait-type "Win")
                            (begin 
                                (map-set common-windows-trait (var-get last-common-windows-id) trait-rle)
                                (var-set last-common-windows-id (+ (var-get last-common-windows-id) u1))
                            )
                            ;; for anchor mast
                            (if (is-eq trait-type "Anc")
                                (begin 
                                    (map-set common-anchor-trait (var-get last-common-anchor-id) trait-rle)
                                    (var-set last-common-anchor-id (+ (var-get last-common-anchor-id) u1))
                                )
                                ;; have to return error here
                                false
                            )
                        )
                    )
                )
            )
        )
        (ok true)
	)
)

;; handled ship rare traits
(define-read-only (get-rare-trait-at-index (id uint) (trait-type (string-ascii 3)))
    ;; for Mas 
    (if (is-eq trait-type "Mas")
        (map-get? rare-mast-trait id)
        ;; for telescope 
        (if (is-eq trait-type "Tel")
            (map-get? rare-telescope-trait id)
            ;; for sails 
            (if (is-eq trait-type "Sai")
                (map-get? rare-sails-trait id)
                ;; for body 
                (if (is-eq trait-type "Bod")
                    (map-get? rare-body-trait id)
                    ;; for windows 
                    (if (is-eq trait-type "Win")
                        (map-get? rare-windows-trait id)
                        ;; for anchor 
                        (if (is-eq trait-type "Anc")
                            (map-get? rare-anchor-trait id)
                            none
                        )
                    )
                )
            )
        )
    )        
)

(define-public (add-rare-trait (trait-rle (string-utf8 20000)) (trait-type (string-ascii 3)))
    (begin
		(asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        ;; for mast
        (if (is-eq trait-type "Mas")
            (begin 
                (map-set rare-mast-trait (var-get last-rare-mast-id) trait-rle)
                (var-set last-rare-mast-id (+ (var-get last-rare-mast-id) u1))
            )
            ;; for telescope 
            (if (is-eq trait-type "Tel")
                (begin 
                    (map-set rare-telescope-trait (var-get last-rare-telescope-id) trait-rle)
                    (var-set last-rare-telescope-id (+ (var-get last-rare-telescope-id) u1))
                )
                ;; for sails 
                (if (is-eq trait-type "Sai")
                    (begin 
                        (map-set rare-sails-trait (var-get last-rare-sails-id) trait-rle)
                        (var-set last-rare-sails-id (+ (var-get last-rare-sails-id) u1))
                    )
                    ;; for body 
                    (if (is-eq trait-type "Bod")
                        (begin 
                            (map-set rare-body-trait (var-get last-rare-body-id) trait-rle)
                            (var-set last-rare-body-id (+ (var-get last-rare-body-id) u1))
                        )
                        ;; for windows
                        (if (is-eq trait-type "Win")
                            (begin 
                                (map-set rare-windows-trait (var-get last-rare-windows-id) trait-rle)
                                (var-set last-rare-windows-id (+ (var-get last-rare-windows-id) u1))
                            )
                            ;; for anchor 
                            (if (is-eq trait-type "Anc")
                                (begin 
                                    (map-set rare-anchor-trait (var-get last-rare-anchor-id) trait-rle)
                                    (var-set last-rare-anchor-id (+ (var-get last-rare-anchor-id) u1))
                                )
                                ;; have to return error here
                                false
                            )
                        )
                    )
                )
            )
        )
        (ok true)
	)
)

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
            ;; for sails 
            (if (is-eq trait-type "Sai")
                (get-random (var-get last-common-sails-id))
                ;; for body 
                (if (is-eq trait-type "Bod")
                    (get-random (var-get last-common-body-id))
                    ;; for windows 
                    (if (is-eq trait-type "Win")
                        (get-random (var-get last-common-windows-id))
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
            ;; for sails 
            (if (is-eq trait-type "Sai")
                 (get-random (var-get last-rare-sails-id))
                ;; for body 
                (if (is-eq trait-type "Bod")
                    (get-random (var-get last-rare-body-id))
                    ;; for windows 
                    (if (is-eq trait-type "Win")
                        (get-random (var-get last-rare-windows-id))
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

;; minting random pirates
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
                windows : {idx : (get trait-idx window-obj), is-rare : (get is-rare window-obj)},
                anchor : {idx : (get trait-idx anchor-obj), is-rare : (get is-rare anchor-obj)},
                sails : {idx : (get trait-idx sail-obj), is-rare : (get is-rare sail-obj)}
            },
            is-rare: is-rare,
            tov: (* (+ u4 (mod is-rare-val u15)) u3600);; [4-18] hours (in secs)
         }
        )
    )
)

(define-public (get-traits-rle (traits { body: { idx : uint, is-rare : bool }, mast : {idx : uint, is-rare : bool} , telescope : { idx : uint , is-rare : bool} , windows : {idx : uint, is-rare : bool}, anchor : {idx : uint, is-rare : bool}, sails : {idx : uint, is-rare : bool}})) 
    (ok
        { 
            body :  (if (get is-rare (get body traits)) (map-get? rare-body-trait (get idx (get body traits))) (map-get? common-body-trait (get idx (get body traits)))),
            mast : (if (get is-rare (get mast traits)) (map-get? rare-mast-trait (get idx (get mast traits))) (map-get? common-mast-trait (get idx (get mast traits)))),
            telescope : (if (get is-rare (get telescope traits)) (map-get? rare-telescope-trait (get idx (get telescope traits))) (map-get? common-telescope-trait (get idx (get telescope traits)))),
            windows : (if (get is-rare (get windows traits)) (map-get? rare-windows-trait (get idx (get windows traits))) (map-get? common-windows-trait (get idx (get windows traits)))),
            anchor : (if (get is-rare (get anchor traits)) (map-get? rare-anchor-trait (get idx (get anchor traits))) (map-get? common-anchor-trait (get idx (get anchor traits)))),
            sails : (if (get is-rare (get sails traits)) (map-get? rare-sails-trait (get idx (get sails traits))) (map-get? common-sails-trait (get idx (get sails traits))))
        }
    )
)



