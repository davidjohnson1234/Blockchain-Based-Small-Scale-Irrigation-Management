;; Water Source Registration Contract
;; Records details of shared water resources

(define-data-var last-id uint u0)

(define-map water-sources
  { id: uint }
  {
    name: (string-ascii 100),
    location: (string-ascii 100),
    capacity: uint,
    source-type: (string-ascii 50),
    owner: principal,
    active: bool
  }
)

;; Register water source
(define-public (register
    (name (string-ascii 100))
    (location (string-ascii 100))
    (capacity uint)
    (source-type (string-ascii 50))
  )
  (let
    (
      (new-id (+ (var-get last-id) u1))
    )
    (var-set last-id new-id)

    (map-set water-sources
      { id: new-id }
      {
        name: name,
        location: location,
        capacity: capacity,
        source-type: source-type,
        owner: tx-sender,
        active: true
      }
    )

    (ok new-id)
  )
)

;; Update water source status
(define-public (update-status
    (source-id uint)
    (active bool)
  )
  (let
    (
      (source (unwrap! (map-get? water-sources { id: source-id }) (err u404)))
    )
    (asserts! (is-eq tx-sender (get owner source)) (err u403))

    (map-set water-sources
      { id: source-id }
      (merge source { active: active })
    )

    (ok true)
  )
)

;; Get water source
(define-read-only (get-water-source (id uint))
  (map-get? water-sources { id: id })
)
