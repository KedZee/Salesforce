public with sharing class queueExecutorService implements Queueable {
    queueServiseInterface jobLogic;

    public queueExecutorService(queueServiseInterface jobLogic) {
        this.jobLogic = jobLogic;
    }

    public void execute(QueueableContext context) {
        this.jobLogic.executeQuequeLogic();

        if(this.jobLogic.hasToRepeatExecution()) {
            System.enqueueJob(new QueueExecutorService(this.jobLogic));
        }
        
    }
}