;; Usage Scheduling Contract
;; Manages equitable water distribution

(define-data-var last-id uint u0)

(define-map schedules
  { id: uint }
  {
    water-source-id: uint,
    farmer: principal,
    start-time: uint,
    end-time: uint,
    allocation: uint,
    status: (string-ascii 20)
  }
)

;; Request water allocation
(define-public (request-allocation
    (water-source-id uint)
    (start-time uint)
    (end-time uint)
    (allocation uint)
  )
  (let
    (
      (new-id (+ (var-get last-id) u1))
    )
    (var-set last-id new-id)

    (map-set schedules
      { id: new-id }
      {
        water-source-id: water-source-id,
        farmer: tx-sender,
        start-time: start-time,
        end-time: end-time,
        allocation: allocation,
        status: "pending"
      }
    )

    (ok new-id)
  )
)

;; Approve allocation
(define-public (approve-allocation
    (schedule-id uint)
  )
  (let
    (
      (schedule (unwrap! (map-get? schedules { id: schedule-id }) (err u404)))
    )

    (map-set schedules
      { id: schedule-id }
      (merge schedule { status: "approved" })
    )

    (ok true)
  )
)

;; Complete usage
(define-public (complete-usage
    (schedule-id uint)
  )
  (let
    (
      (schedule (unwrap! (map-get? schedules { id: schedule-id }) (err u404)))
    )
    (asserts! (is-eq tx-sender (get farmer schedule)) (err u403))

    (map-set schedules
      { id: schedule-id }
      (merge schedule { status: "completed" })
    )

    (ok true)
  )
)

;; Get schedule
(define-read-only (get-schedule (id uint))
  (map-get? schedules { id: id })
)
