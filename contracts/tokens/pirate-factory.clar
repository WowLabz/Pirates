(define-constant ERR-NOT-AUTHORIZED (err u401))


(define-data-var contract-owner principal tx-sender)
(define-data-var common-trait-value uint u2)
(define-data-var rare-trait-value uint u3)
;; A map that creates a id => rle string relation.
;; hat 
(define-map common-hat-trait uint (string-utf8 20000))
(define-data-var last-common-hat-id uint u0)
(define-map rare-hat-trait uint (string-utf8 20000))
(define-data-var last-rare-hat-id uint u0)
;; bottom
(define-map common-bottom-trait uint (string-utf8 20000))
(define-data-var last-common-bottom-id uint u0)
(define-map rare-bottom-trait uint (string-utf8 20000))
(define-data-var last-rare-bottom-id uint u0)
;; face
(define-map common-face-trait uint (string-utf8 20000))
(define-data-var last-common-face-id uint u0)
(define-map rare-face-trait uint (string-utf8 20000))
(define-data-var last-rare-face-id uint u0)
;; hand
(define-map common-hand-trait uint (string-utf8 20000))
(define-data-var last-common-hand-id uint u0)
(define-map rare-hand-trait uint (string-utf8 20000))
(define-data-var last-rare-hand-id uint u0)
;; sword
(define-map common-sword-trait uint (string-utf8 20000))
(define-data-var last-common-sword-id uint u0)
(define-map rare-sword-trait uint (string-utf8 20000))
(define-data-var last-rare-sword-id uint u0)
;; top
(define-map common-top-trait uint (string-utf8 20000))
(define-data-var last-common-top-id uint u0)
(define-map rare-top-trait uint (string-utf8 20000))
(define-data-var last-rare-top-id uint u0)

;; function related to hat trait of pirate
;; handled common traits
(define-read-only (get-common-trait-at-index (id uint) (trait-type (string-ascii 3)))
    ;; for pirate bottom
    (if (is-eq trait-type "Bot")
        (map-get? common-bottom-trait id)
        ;; for pirate face 
        (if (is-eq trait-type "Fac")
            (map-get? common-face-trait id)
            ;; for pirate hand
            (if (is-eq trait-type "Han")
                (map-get? common-hand-trait id)
                ;; for pirate hat
                (if (is-eq trait-type "Hat")
                    (map-get? common-hat-trait id)
                    ;; for pirate top
                    (if (is-eq trait-type "Top")
                        (map-get? common-top-trait id)
                        ;; for pirate sword
                        (if (is-eq trait-type "Swo")
                            (map-get? common-sword-trait id)
                            ;; solve this, have to return err saying no trait found with given trait type
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
        ;; for pirate bottom
        (if (is-eq trait-type "Bot")
            (begin  
                (map-set common-bottom-trait (var-get last-common-bottom-id) trait-rle)
                (var-set last-common-bottom-id (+ (var-get last-common-bottom-id) u1))
            )
            ;; for face bottom
            (if (is-eq trait-type "Fac")
                (begin 
                    (map-set common-face-trait (var-get last-common-face-id) trait-rle)
                    (var-set last-common-face-id (+ (var-get last-common-face-id) u1))
                )
                ;; for hand bottom
                (if (is-eq trait-type "Han")
                    (begin 
                        (map-set common-hand-trait (var-get last-common-hand-id) trait-rle)
                        (var-set last-common-hand-id (+ (var-get last-common-hand-id) u1))
                    )
                    ;; for hat bottom
                    (if (is-eq trait-type "Hat")
                        (begin 
                            (map-set common-hat-trait (var-get last-common-hat-id) trait-rle)
                            (var-set last-common-hat-id (+ (var-get last-common-hat-id) u1))
                        )
                        ;; for top bottom
                        (if (is-eq trait-type "Top")
                            (begin 
                                (map-set common-top-trait (var-get last-common-top-id) trait-rle)
                                (var-set last-common-top-id (+ (var-get last-common-top-id) u1))
                            )
                            ;; for sword bottom
                            (if (is-eq trait-type "Swo")
                                (begin 
                                    (map-set common-sword-trait (var-get last-common-sword-id) trait-rle)
                                    (var-set last-common-sword-id (+ (var-get last-common-sword-id) u1))
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

;; handled rare traits
(define-read-only (get-rare-trait-at-index (id uint) (trait-type (string-ascii 3)))
    ;; for pirate bottom
    (if (is-eq trait-type "Bot")
        (map-get? rare-bottom-trait id)
        ;; for face bottom
        (if (is-eq trait-type "Fac")
            (map-get? rare-face-trait id)
            ;; for hand bottom
            (if (is-eq trait-type "Han")
                (map-get? rare-hand-trait id)
                ;; for hat bottom
                (if (is-eq trait-type "Hat")
                    (map-get? rare-hat-trait id)
                    ;; for top bottom
                    (if (is-eq trait-type "Top")
                        (map-get? rare-top-trait id)
                        ;; for sword bottom
                        (if (is-eq trait-type "Swo")
                            (map-get? rare-sword-trait id)
                            ;; solve this, have to return err saying no trait found with given trait type
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
        ;; for pirate bottom
        (if (is-eq trait-type "Bot")
            (begin 
                (map-set rare-bottom-trait (var-get last-rare-bottom-id) trait-rle)
                (var-set last-rare-bottom-id (+ (var-get last-rare-bottom-id) u1))
            )
            ;; for face bottom
            (if (is-eq trait-type "Fac")
                (begin 
                    (map-set rare-face-trait (var-get last-rare-face-id) trait-rle)
                    (var-set last-rare-face-id (+ (var-get last-rare-face-id) u1))
                )
                ;; for hand bottom
                (if (is-eq trait-type "Han")
                    (begin 
                        (map-set rare-hand-trait (var-get last-rare-hand-id) trait-rle)
                        (var-set last-rare-hand-id (+ (var-get last-rare-hand-id) u1))
                    )
                    ;; for hat bottom
                    (if (is-eq trait-type "Hat")
                        (begin 
                            (map-set rare-hat-trait (var-get last-rare-hat-id) trait-rle)
                            (var-set last-rare-hat-id (+ (var-get last-rare-hat-id) u1))
                        )
                        ;; for top bottom
                        (if (is-eq trait-type "Top")
                            (begin 
                                (map-set rare-top-trait (var-get last-rare-top-id) trait-rle)
                                (var-set last-rare-top-id (+ (var-get last-rare-top-id) u1))
                            )
                            ;; for sword bottom
                            (if (is-eq trait-type "Swo")
                                (begin 
                                    (map-set rare-sword-trait (var-get last-rare-sword-id) trait-rle)
                                    (var-set last-rare-sword-id (+ (var-get last-rare-sword-id) u1))
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
        (contract-call? .random-number get-random max u48943)
    )
)
;; minting random pirates
(define-private (select-from-common (trait-type (string-ascii 3)))
   ;; for bottom
    (if (is-eq trait-type "Bot")
            (get-random (var-get last-common-bottom-id))
        ;; for face 
        (if (is-eq trait-type "Fac")
            (get-random (var-get last-common-face-id))
            ;; for hand 
            (if (is-eq trait-type "Han")
                (get-random (var-get last-common-hand-id))
                ;; for hat 
                (if (is-eq trait-type "Hat")
                    (get-random (var-get last-common-hat-id))
                    ;; for Top
                    (if (is-eq trait-type "Top")
                        (get-random (var-get last-common-top-id))
                        ;; for sword 
                        (if (is-eq trait-type "Swo")
                             (get-random (var-get last-common-sword-id))
                            ;; solve this, have to return err saying no trait found with given trait type
                            (get-random (var-get last-common-sword-id))
                        )
                    )
                )
            )
        )
    )  
)

(define-private (select-from-rare (trait-type (string-ascii 3)))
   ;; for bottom
    (if (is-eq trait-type "Bot")
            (get-random (var-get last-rare-bottom-id))
        ;; for face 
        (if (is-eq trait-type "Fac")
            (get-random (var-get last-rare-face-id))
            ;; for hand 
            (if (is-eq trait-type "Han")
                (get-random (var-get last-rare-hand-id))
                ;; for hat 
                (if (is-eq trait-type "Hat")
                    (get-random (var-get last-rare-hat-id))
                    ;; for Top
                    (if (is-eq trait-type "Top")
                        (get-random (var-get last-rare-top-id))
                        ;; for sword 
                        (if (is-eq trait-type "Swo")
                             (get-random (var-get last-rare-sword-id))
                            ;; solve this, have to return err saying no trait found with given trait type
                            (get-random (var-get last-rare-sword-id))
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
        ;;TODO: (if (> (+ chance-random (contract-call? .game get-user-buffer tx-sender) u90) 
        (if (> u89 u90) 
            (begin
                ;; if 1 then choose from rare else from common
                (if (is-eq (unwrap-panic (contract-call? .random-number get-random u2 u328)) u1)
                    (ok { is-rare : true , is-rare-val : (var-get rare-trait-value), trait-idx : (select-from-rare trait-type)})
                    (ok { is-rare : false, is-rare-val : (var-get common-trait-value), trait-idx : (select-from-common trait-type)})
                )
            )
            ;; always common
            (ok { is-rare : false, is-rare-val : (var-get rare-trait-value), trait-idx : (select-from-rare trait-type)})
        )
	)
)

;; minting random pirates
(define-public (get-random-traits)
    (let
        (
            (bottom-obj (unwrap-panic (select-random-trait "Bot"))) 
            (face-obj (unwrap-panic (select-random-trait "Fac")))
            (hand-obj (unwrap-panic (select-random-trait "Han"))) 
            (hat-obj (unwrap-panic (select-random-trait "Hat")))
            (top-obj (unwrap-panic (select-random-trait "Top"))) 
            (sword-obj (unwrap-panic (select-random-trait "Swo")))
            (is-rare-val (fold + (list (get is-rare-val bottom-obj) (get is-rare-val face-obj) (get is-rare-val hand-obj) (get is-rare-val hat-obj) (get is-rare-val top-obj) (get is-rare-val sword-obj)) u0))
            (is-rare (if (>= is-rare-val u16) true false))
        )
        (ok {
            traits: {  
                Bottom : { idx : (get trait-idx bottom-obj) , is-rare : (get is-rare bottom-obj)},
                Face : { idx : (get trait-idx face-obj) , is-rare : (get is-rare face-obj)},
                Hand : { idx : (get trait-idx hand-obj) , is-rare : (get is-rare hand-obj)},
                Hat : { idx : (get trait-idx hat-obj) , is-rare : (get is-rare hat-obj)},
                Top : { idx : (get trait-idx top-obj) , is-rare : (get is-rare top-obj)},
                Sword : { idx : (get trait-idx sword-obj) , is-rare : (get is-rare sword-obj)}
            },
            is-rare: is-rare,
            fear-factor: (+ u6 (mod is-rare-val u2)) ;; [6-8]
         }
        )
    )
)


(define-public (get-traits-rle (traits {  Bottom : { idx : uint, is-rare : bool}, Face : { idx : uint, is-rare : bool}, Hand : { idx : uint, is-rare : bool}, Hat : { idx : uint, is-rare : bool}, Top : { idx : uint, is-rare : bool}, Sword : { idx : uint, is-rare : bool} })) 
    (ok
        { 
            Bottom : (unwrap-panic (if (get is-rare (get Bottom traits)) (map-get? rare-bottom-trait (get idx (get Bottom traits))) (map-get? common-bottom-trait (get idx (get Bottom traits))))),
            Face : (unwrap-panic (if (get is-rare (get Face traits)) (map-get? rare-face-trait (get idx (get Face traits))) (map-get? common-face-trait (get idx (get Face traits))))),
            Hand : (unwrap-panic (if (get is-rare (get Hand traits)) (map-get? rare-hand-trait (get idx (get Hand traits))) (map-get? common-hand-trait (get idx (get Hand traits))))),
            Hat : (unwrap-panic (if (get is-rare (get Hat traits)) (map-get? rare-hat-trait (get idx (get Hat traits))) (map-get? common-hat-trait (get idx (get Hat traits))))),
            Top : (unwrap-panic (if (get is-rare (get Top traits)) (map-get? rare-top-trait (get idx (get Top traits))) (map-get? common-top-trait (get idx (get Top traits))))),
            Sword : (unwrap-panic (if (get is-rare (get Sword traits)) (map-get? rare-sword-trait (get idx (get Sword traits))) (map-get? common-sword-trait (get idx (get Sword traits)))))
        }
    )
)

