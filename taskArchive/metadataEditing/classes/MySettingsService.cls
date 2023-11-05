public with sharing class MySettingsService implements ISettingsService {

    public interface ISettingsService {
        // SettingsService.MetadataResultDTO prepareSettings();
        // SettingsService.MetadataResultDTO prepareSettings(
        //     SettingsService.MetadataResultDTO inputData
        // );
        void updateSettings(String metadataText, String label);
        // void updateSettings(
        //     SettingsService.MetadataResultDTO settingsList
        // );
        // void updateFlagSetting(String inputData);
        // void updateFlagSetting(
        //     SettingsService.MetadataFlagDTO flagSetting
        // );
    }

    public static final String EXPORT_DOWNLOAD_ATTEMPTS = 'EXPORT_DOWNLOAD_ATTEMPTS';

    private final MySettingsService.MetadataSettingDTO EXPORT_DOWNLOAD_ATTEMPTS = new MySettingsService.MetadataSettingDTO(SettingsService.INPUT_TYPE, EXPORT_DOWNLOAD_ATTEMPTS);

    private String valueMetadataApiName {
        get {
            return Settings__mdt.SObjectType.getDescribe().getName();
        }
        set;
    }

    public void updateSettings(String metadataText, String label) {
        try {
            // SettingsService.MetadataResultDTO settingsList = (SettingsService.MetadataResultDTO)
            //     JSON.deserialize(
            //         settingsString,
            //         SettingsService.MetadataResultDTO.class
            //     );
            
            //system.debug('settingsList===' + JSON.serialize(settingsList));
            //this.validateSettings(settingsList);
            //this.updateSettings(settingsList);
        } catch (Exception ex) {
            throw new InCountryMetadataException('Bad attempt to generate new metadata');
        }
    }

    public static MySettingsService.ISettingsService newInstance() {
        return (MySettingsService.ISettingsService) Application.Service.newInstance(
            MySettingsService.ISettingsService.class
        );
    }

    public class MetadataSettingDTO {
        @AuraEnabled public Id id;
        @AuraEnabled public String label;
        @AuraEnabled public String type;
        @AuraEnabled public String description;
        @AuraEnabled public String developerName;
        @AuraEnabled public String value = '';
        @AuraEnabled public String name = '';

        public MetadataSettingDTO(String type, String developerName) {
            this.type = type;
            this.developerName = developerName;
        }

        public void setData(InCountryValue__mdt value) {
            this.id = value.Id;
            this.value = value.Value__c;
            this.name = value.Name__c;
        }
    }
}