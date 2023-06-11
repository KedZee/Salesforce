public with sharing class mockDelays {
    private static final Integer DELAY = 2000;

    @AuraEnabled(cacheable=true)
    public static Integer firstMultiplyBy2(Integer inputNumber) {
        mockDelay();
        return inputNumber * 2;
    }

    @AuraEnabled(cacheable=true)
    public static Integer secondMultiplyBy2(Integer inputNumber) {
        mockDelay();
        return inputNumber * 2;
    }

    @AuraEnabled(cacheable=true)
    public static Integer thirdMultiplyBy2(Integer inputNumber) {
        mockDelay();
        return inputNumber * 2;
    }

    @AuraEnabled(cacheable=true)
    public static Integer fourthMultiplyBy2(Integer inputNumber) {
        mockDelay();
        return inputNumber * 2;
    }

    @AuraEnabled(cacheable=true)
    public static Integer fifthMultiplyBy2(Integer inputNumber) {
        mockDelay();
        return inputNumber * 2;
    }

    private static void mockDelay() {
        Long startTimeInMilliseconds = DateTime.now().getTime();
        while (DateTime.now().getTime() - startTimeInMilliseconds <= DELAY) {}
    }
}