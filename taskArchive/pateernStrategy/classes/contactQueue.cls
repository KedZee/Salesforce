public class contactQueue implements queueServiseInterface {
    private static final Integer LIMIT_OF_ATTEMPS = 4;

    public Boolean isInsert = false;
    public Contact con;
    public Integer numberOfIterations = 0;

    public contactQueue(Contact con) {
        this.con = con;
    }

    public void executeQuequeLogic() {
        try {
            insert this.con;
            this.isInsert = true;
        } catch (Exception e) {
            this.con.Super__c = this.con.Super__c.substring(0, this.con.Super__c.length() - 1);
            this.numberOfIterations = this.numberOfIterations + 1;
        }
    }

    public Boolean hasToRepeatExecution() {
        return !this.isInsert || numberOfIterations < LIMIT_OF_ATTEMPS;
    }
}