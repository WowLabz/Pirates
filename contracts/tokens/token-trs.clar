(impl-trait .sip010-ft-trait.sip010-ft-trait)

(define-fungible-token trs)

(define-data-var token-uri (string-utf8 256) u"")
(define-data-var contract-owner principal tx-sender)
(define-map approved-contracts principal bool)

;; errors
(define-constant ERR-NOT-AUTHORIZED (err u401))

(define-read-only (get-contract-owner)
  (ok (var-get contract-owner))
)

;; @desc check-is-approved
;; @restricted Contract-Owner
;; @params sender
;; @returns (response bool)
(define-private (check-is-approved (sender principal))
  (ok (asserts! (or (default-to false (map-get? approved-contracts sender)) (is-eq sender (var-get contract-owner))) ERR-NOT-AUTHORIZED))
)

(define-public (add-approved-contract (new-approved-contract principal))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
    (map-set approved-contracts new-approved-contract true)
    (ok true)
  )
)

(define-public (set-approved-contract (owner principal) (approved bool))
	(begin
		(asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
		(ok (map-set approved-contracts owner approved))
	)
)



(define-public (transfer-claimed-trs (amount uint) (recipient principal))
  (if (> amount u0)
    (begin
      (asserts! (is-eq (default-to false (map-get? approved-contracts tx-sender)) true) ERR-NOT-AUTHORIZED)
      (try! (ft-mint? trs amount recipient))
      (ok true)
    )
    (ok true)
  )
)

;; ---------------------------------------------------------
;; SIP-10 Functions
;; ---------------------------------------------------------

;; @desc get-total-supply
;; @returns (response uint)
(define-read-only (get-total-supply)
  (ok (ft-get-supply trs))
)

;; @desc get-name
;; @returns (response string-utf8)
(define-read-only (get-name)
  (ok "trs")
)

;; @desc get-symbol
;; @returns (response string-utf8)
(define-read-only (get-symbol)
  (ok "TRS")
)

;; @desc get-decimals
;; @returns (response uint)
(define-read-only (get-decimals)
   	(ok u6)
)

;; @desc get-balance
;; @params token-id
;; @params who
;; @returns (response uint)
(define-read-only (get-balance (account principal))
  (ok (ft-get-balance trs account))
)

;; @desc set-token-uri
;; @restricted Contract-Owner
;; @params value
;; @returns (response bool)
(define-public (set-token-uri (value (string-utf8 256)))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
    (ok (var-set token-uri value))
  )
)

;; @desc get-token-uri 
;; @params token-id
;; @returns (response none)
(define-read-only (get-token-uri)
  (ok (some (var-get token-uri)))
)

;; @desc transfer
;; @restricted sender
;; @params token-id 
;; @params amount
;; @params sender
;; @params recipient
;; @returns (response boolean)
(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (begin
    (asserts! (is-eq sender tx-sender) ERR-NOT-AUTHORIZED)
    (try! (ft-transfer? trs amount sender recipient))
    (match memo to-print (print to-print) 0x)
    (ok true)
  )
)

;; @desc burn
;; @restricted ContractOwner/Approved Contract
;; @params token-id
;; @params amount
;; @params sender
;; @returns (response boolean)
(define-public (burn (amount uint) (sender principal))
  (begin
    (try! (check-is-approved tx-sender))
    (ft-burn? trs amount sender)
  )
)

(define-constant ONE_8 u100000000)

;; @desc pow-decimals
;; @returns uint
(define-private (pow-decimals)
  (pow u10 (unwrap-panic (get-decimals)))
)

;; @desc fixed-to-decimals
;; @params amount
;; @returns uint
(define-read-only (fixed-to-decimals (amount uint))
  (/ (* amount (pow-decimals)) ONE_8)
)

;; @desc decimals-to-fixed 
;; @params amount
;; @returns uint
(define-private (decimals-to-fixed (amount uint))
  (/ (* amount ONE_8) (pow-decimals))
)

;; @desc get-total-supply-fixed
;; @params token-id
;; @returns (response uint)
(define-read-only (get-total-supply-fixed)
  (ok (decimals-to-fixed (ft-get-supply trs)))
)

;; @desc get-balance-fixed
;; @params token-id
;; @params who
;; @returns (response uint)
(define-read-only (get-balance-fixed (account principal))
  (ok (decimals-to-fixed (ft-get-balance trs account)))
)

;; @desc transfer-fixed
;; @params token-id
;; @params amount
;; @params sender
;; @params recipient
;; @returns (response boolean)
(define-public (transfer-fixed (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (transfer (fixed-to-decimals amount) sender recipient memo)
)

;; @desc burn-fixed
;; @params token-id
;; @params amount
;; @params sender
;; @returns (response boolean)
(define-public (burn-fixed (amount uint) (sender principal))
  (burn (fixed-to-decimals amount) sender)
)

(map-set approved-contracts .pirate-factory true)
(map-set approved-contracts .ship-factory true)
(map-set approved-contracts .pirate-nft true)
(map-set approved-contracts .ship-nft true)
