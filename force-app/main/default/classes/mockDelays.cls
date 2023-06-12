public with sharing class mockDelays {
    private static final Integer DELAY = 2000;

    @AuraEnabled(cacheable=true)
    public static Integer multiplyBy2(Integer inputNumber) {
        mockDelay();
        return inputNumber * 2;
    }

    @AuraEnabled(cacheable=true)
    public static Integer multiplyBy3(Integer inputNumber) {
        mockDelay();
        return inputNumber * 2;
    }

    @AuraEnabled(cacheable=true)
    public static Integer multiplyBy4(Integer inputNumber) {
        mockDelay();
        return inputNumber * 2;
    }

    @AuraEnabled(cacheable=true)
    public static Integer multiplyBy5(Integer inputNumber) {
        mockDelay();
        return inputNumber * 2;
    }

    @AuraEnabled(cacheable=true)
    public static Integer multiplyBy6(Integer inputNumber) {
        mockDelay();
        return inputNumber * 2;
    }

    private static void mockDelay() {
        Long startTimeInMilliseconds = DateTime.now().getTime();
        while (DateTime.now().getTime() - startTimeInMilliseconds <= DELAY) {}
    }
}