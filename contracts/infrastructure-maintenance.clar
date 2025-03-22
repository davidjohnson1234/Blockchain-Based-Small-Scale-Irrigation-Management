;; Infrastructure Maintenance Contract
;; Tracks upkeep of shared systems

(define-data-var last-id uint u0)

(define-map maintenance-tasks
  { id: uint }
  {
    water-source-id: uint,
    description: (string-ascii 200),
    scheduled-date: uint,
    technician: principal,
    cost: uint,
    status: (string-ascii 20)
  }
)

;; Schedule maintenance
(define-public (schedule-maintenance
    (water-source-id uint)
    (description (string-ascii 200))
    (scheduled-date uint)
    (cost uint)
  )
  (let
    (
      (new-id (+ (var-get last-id) u1))
    )
    (var-set last-id new-id)

    (map-set maintenance-tasks
      { id: new-id }
      {
        water-source-id: water-source-id,
        description: description,
        scheduled-date: scheduled-date,
        technician: tx-sender,
        cost: cost,
        status: "scheduled"
      }
    )

    (ok new-id)
  )
)

;; Complete maintenance
(define-public (complete-maintenance
    (task-id uint)
  )
  (let
    (
      (task (unwrap! (map-get? maintenance-tasks { id: task-id }) (err u404)))
    )
    (asserts! (is-eq tx-sender (get technician task)) (err u403))

    (map-set maintenance-tasks
      { id: task-id }
      (merge task { status: "completed" })
    )

    (ok true)
  )
)

;; Get maintenance task
(define-read-only (get-maintenance-task (id uint))
  (map-get? maintenance-tasks { id: id })
)
