(define-constant ERR-NOT-AUTHORIZED (err u401))


(define-data-var contract-owner principal tx-sender)
(define-data-var common-trait-value uint u2)
(define-data-var rare-trait-value uint u3)
(define-data-var game-contract principal tx-sender)
(define-data-var rd-contract principal tx-sender)

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

(define-public (set-game-contract (game-principal principal))
    (begin 
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        (var-set game-contract game-principal)
        (ok true)
    )
)

(define-public (set-rd-contract (rd-principal principal))
    (begin 
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        (var-set rd-contract rd-principal)
        (ok true)
    )
)

;; addition:common-trait
(define-public (add-common-bottom-trait (trait-rle (string-utf8 20000))) 
    (begin 
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        (map-set common-bottom-trait (var-get last-common-bottom-id) trait-rle)
        (var-set last-common-bottom-id (+ (var-get last-common-bottom-id) u1))
        (ok true)
    )
)
(define-public (add-common-face-trait (trait-rle (string-utf8 20000))) 
    (begin 
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        (map-set common-face-trait (var-get last-common-face-id) trait-rle)
        (var-set last-common-face-id (+ (var-get last-common-face-id) u1))
        (ok true)
    )
)
(define-public (add-common-hand-trait (trait-rle (string-utf8 20000))) 
    (begin 
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        (map-set common-hand-trait (var-get last-common-hand-id) trait-rle)
        (var-set last-common-hand-id (+ (var-get last-common-hand-id) u1))
        (ok true)
    )
)
(define-public (add-common-hat-trait (trait-rle (string-utf8 20000))) 
    (begin 
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        (map-set common-hat-trait (var-get last-common-hat-id) trait-rle)
        (var-set last-common-hat-id (+ (var-get last-common-hat-id) u1))
        (ok true)
    )
)
(define-public (add-common-top-trait (trait-rle (string-utf8 20000))) 
    (begin 
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        (map-set common-top-trait (var-get last-common-top-id) trait-rle)
        (var-set last-common-top-id (+ (var-get last-common-top-id) u1))
        (ok true)
    )

)
(define-public (add-common-sword-trait (trait-rle (string-utf8 20000))) 
    (begin 
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        (map-set common-sword-trait (var-get last-common-sword-id) trait-rle)
        (var-set last-common-sword-id (+ (var-get last-common-sword-id) u1))
        (ok true)
    )
)

;; addition:rare-trait
(define-public (add-rare-bottom-trait (trait-rle (string-utf8 20000))) 
    (begin 
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        (map-set rare-bottom-trait (var-get last-rare-bottom-id) trait-rle)
        (var-set last-rare-bottom-id (+ (var-get last-rare-bottom-id) u1))
        (ok true)
    )
)
(define-public (add-rare-face-trait (trait-rle (string-utf8 20000))) 
    (begin 
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        (map-set rare-face-trait (var-get last-rare-face-id) trait-rle)
        (var-set last-rare-face-id (+ (var-get last-rare-face-id) u1))
        (ok true)
    )
)
(define-public (add-rare-hand-trait (trait-rle (string-utf8 20000))) 
    (begin 
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        (map-set rare-hand-trait (var-get last-rare-hand-id) trait-rle)
        (var-set last-rare-hand-id (+ (var-get last-rare-hand-id) u1))
        (ok true)
    )
)
(define-public (add-rare-hat-trait (trait-rle (string-utf8 20000))) 
    (begin 
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        (map-set rare-hat-trait (var-get last-rare-hat-id) trait-rle)
        (var-set last-rare-hat-id (+ (var-get last-rare-hat-id) u1))
        (ok true)
    )
)
(define-public (add-rare-top-trait (trait-rle (string-utf8 20000))) 
    (begin 
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        (map-set rare-top-trait (var-get last-rare-top-id) trait-rle)
        (var-set last-rare-top-id (+ (var-get last-rare-top-id) u1))
        (ok true)
    )

)
(define-public (add-rare-sword-trait (trait-rle (string-utf8 20000))) 
    (begin 
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        (map-set rare-sword-trait (var-get last-rare-sword-id) trait-rle)
        (var-set last-rare-sword-id (+ (var-get last-rare-sword-id) u1))
        (ok true)
    )
)

;; get:common-traits by index
(define-read-only (get-common-bottom-trait-idx (idx uint)) 
    (map-get? common-bottom-trait idx)
)
(define-read-only (get-common-face-trait-idx (idx uint)) 
    (map-get? common-face-trait idx)
)
(define-read-only (get-common-hand-trait-idx (idx uint)) 
    (map-get? common-hand-trait idx)
)
(define-read-only (get-common-hat-trait-idx (idx uint)) 
    (map-get? common-hat-trait idx)
)
(define-read-only (get-common-top-trait-idx (idx uint)) 
    (map-get? common-top-trait idx)
)
(define-read-only (get-common-sword-trait-idx (idx uint)) 
    (map-get? common-sword-trait idx)
)

;; get:rare-traits by index
(define-read-only (get-rare-bottom-trait-idx (idx uint)) 
    (map-get? rare-bottom-trait idx)
)
(define-read-only (get-rare-face-trait-idx (idx uint)) 
    (map-get? rare-face-trait idx)
)
(define-read-only (get-rare-hand-trait-idx (idx uint)) 
    (map-get? rare-hand-trait idx)
)
(define-read-only (get-rare-hat-trait-idx (idx uint)) 
    (map-get? rare-hat-trait idx)
)
(define-read-only (get-rare-top-trait-idx (idx uint)) 
    (map-get? rare-top-trait idx)
)
(define-read-only (get-rare-sword-trait-idx (idx uint)) 
    (map-get? rare-sword-trait idx)
)

;; minting random pirates
(define-private (get-random (max uint))
    (unwrap-panic 
        (contract-call? .random-number get-random max u48943)
    )
)
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
                            u0
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
                            u0
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
            (ok { is-rare : false, is-rare-val : (var-get common-trait-value), trait-idx : (select-from-common trait-type)})
        )
	)
)

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
                bottom : { idx : (get trait-idx bottom-obj) , is-rare : (get is-rare bottom-obj)},
                face : { idx : (get trait-idx face-obj) , is-rare : (get is-rare face-obj)},
                hand : { idx : (get trait-idx hand-obj) , is-rare : (get is-rare hand-obj)},
                hat : { idx : (get trait-idx hat-obj) , is-rare : (get is-rare hat-obj)},
                top : { idx : (get trait-idx top-obj) , is-rare : (get is-rare top-obj)},
                sword : { idx : (get trait-idx sword-obj) , is-rare : (get is-rare sword-obj)}
            },
            is-rare: is-rare,
            fear-factor: (+ u6 (mod is-rare-val u2)) ;; [6-8]
         }
        )
    )
)

;; get-traits-rle
(define-public (get-traits-rle (traits {  bottom : { idx : uint, is-rare : bool}, face : { idx : uint, is-rare : bool}, hand : { idx : uint, is-rare : bool}, hat : { idx : uint, is-rare : bool}, top : { idx : uint, is-rare : bool}, sword : { idx : uint, is-rare : bool} })) 
    (ok
        { 
            bottom : (if (get is-rare (get bottom traits)) (get-rare-bottom-trait-idx (get idx (get bottom traits))) (get-common-bottom-trait-idx (get idx (get bottom traits)))),
            face : (if (get is-rare (get face traits)) (get-rare-face-trait-idx (get idx (get face traits))) (get-common-face-trait-idx (get idx (get face traits)))),
            hand : (if (get is-rare (get hand traits)) (get-rare-hand-trait-idx (get idx (get hand traits))) (get-common-hand-trait-idx (get idx (get hand traits)))),
            hat : (if (get is-rare (get hat traits)) (get-rare-hat-trait-idx (get idx (get hat traits))) (get-common-hat-trait-idx (get idx (get hat traits)))),
            top : (if (get is-rare (get top traits)) (get-rare-top-trait-idx (get idx (get top traits))) (get-common-top-trait-idx (get idx (get top traits)))),
            sword : (if (get is-rare (get sword traits)) (get-rare-sword-trait-idx (get idx (get sword traits))) (get-common-sword-trait-idx (get idx (get sword traits))))
        }
    )
)
