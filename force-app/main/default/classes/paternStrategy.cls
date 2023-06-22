public with sharing class paternStrategy {
    private List<String> gemerInfo;

    public static void callPaternStrategy() {
        List<Account> accList = [SELECT Name FROM Account WHERE Name = 'test Account Name' ];
        List<Contact> conList = [SELECT FirstName, LastName, NickName__c FROM Contact WHERE LastName = 'test LastName' ];
        List<customObject__c> custObjList = [SELECT externalNickName__c, externalId__c  FROM customObject__c WHERE externalNickName__c = 'test123' ];
        

        system.debug('accList===' + accList);
        system.debug('conList===' + conList);
        system.debug('custObjList===' + custObjList);
    }

    public class wrapAccount {
        public String name {get; set;}
 
        public wrapAccount (Account record) {
            name = record.Name;
        }
    }

    public class wrapContact {
        public String name {get; set;}
 
        public wrapContact(Contact record) {
            name = record.FirstName + ' (' + record.NickName__c +') ' + record.LastName;
        }
    }

    public class wrapCustomObject {
        public String name {get; set;}
 
        public wrapCustomObject(customObject__c record) {
            name = record.externalNickName__c + ' - ' + record.externalId__c;
        }
    }
}