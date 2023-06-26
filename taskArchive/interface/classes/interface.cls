public with sharing class paternStrategy {

    public static void callPaternStrategy() {
        List<String> gemerInfo = new List<String>();

        GamerWrap obj = new WrapAccount();
        gemerInfo.addAll(obj.getGamerName());
        obj = new WrapContact();
        gemerInfo.addAll(obj.getGamerName());
        obj = new WrapCustomObject();
        gemerInfo.addAll(obj.getGamerName());
        
        system.debug('gemerInfo===' + gemerInfo);

    }

    public interface GamerWrap {
        List<String> getGamerName();
    }

    public class WrapAccount implements GamerWrap {

        public List<String> getGamerName () {
            List<String> name = new List<String>();

            List<Account> accList = [SELECT Name FROM Account WHERE Name = 'test Account Name' ];
            
            for (Account acc : accList) {
                name.add(acc.Name);
            }

            return name;
        }
    }

    public class WrapContact implements GamerWrap {

        public List<String> getGamerName () {
            List<String> name = new List<String>();

            List<Contact> conList = [SELECT FirstName, LastName, NickName__c FROM Contact WHERE LastName = 'test LastName' ];

            for (Contact con : conList) {
                name.add(con.FirstName + ' (' + con.NickName__c +') ' + con.LastName);
            }
            return name;
        }
    }

    public class WrapCustomObject implements GamerWrap {

        public List<String> getGamerName () {
            List<String> name = new List<String>();

            List<customObject__c> custObjList = [SELECT externalNickName__c, externalId__c  FROM customObject__c WHERE externalNickName__c = 'test123' ];

            for (customObject__c cust : custObjList) {
                name.add(cust.externalNickName__c + ' - ' + cust.externalId__c);
            }
            return name;
        }
    }
}