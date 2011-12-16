; ModuleID = 'forbarrier2_loops_btr.ll'

declare void @pocl.barrier()

define void @forbarrier2() {
a.loopbarrier.prebarrier:
  br label %a.loopbarrier

a.loopbarrier:                                    ; preds = %a.loopbarrier.prebarrier
  call void @pocl.barrier()
  br label %b.loopbarrier.prebarrier

b.loopbarrier.prebarrier:                         ; preds = %c.latchbarrier.postbarrier, %a.loopbarrier
  br label %b.loopbarrier

b.loopbarrier:                                    ; preds = %b.loopbarrier.prebarrier
  call void @pocl.barrier()
  br label %barrier.prebarrier

barrier.prebarrier:                               ; preds = %barrier.postbarrier, %b.loopbarrier
  br label %barrier

barrier:                                          ; preds = %barrier.prebarrier
  call void @pocl.barrier()
  br label %barrier.postbarrier

barrier.postbarrier:                              ; preds = %barrier
  br i1 true, label %barrier.prebarrier, label %c.latchbarrier.prebarrier

c.latchbarrier.prebarrier:                        ; preds = %barrier.postbarrier
  br label %c.latchbarrier

c.latchbarrier:                                   ; preds = %c.latchbarrier.prebarrier
  call void @pocl.barrier()
  br label %c.latchbarrier.postbarrier

c.latchbarrier.postbarrier:                       ; preds = %c.latchbarrier
  br i1 true, label %b.loopbarrier.prebarrier, label %d

d:                                                ; preds = %c.latchbarrier.postbarrier
  ret void
}
