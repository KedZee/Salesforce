/**
 * @description       : Apex controller to manage Custom Metadata Settings
 * @since             : 19-07-2022
**/
public with sharing class SettingsService implements ISettingsService {

    public interface ISettingsService {
        // SettingsService.MetadataResultDTO prepareSettings();
        // SettingsService.MetadataResultDTO prepareSettings(
        //     SettingsService.MetadataResultDTO inputData
        // );
        void updateSettings(String metadataText, String label);
        void updateSettings(
            SettingsService.MetadataResultDTO settingsList
        );
        // void updateFlagSetting(String inputData);
        // void updateFlagSetting(
        //     SettingsService.MetadataFlagDTO flagSetting
        // );
    }

    private static final String REGEXP_REPORT_REQUESTS_ATTEMPTS = '^([1-9]|[1-4]\\d|50)$';

    private static final String INPUT_TYPE = 'input';
    private static final String TOGGLE_TYPE = 'toggle';

    public static final String EXP = 'exp';
    public static final String EXPORT_DOWNLOAD_ATTEMPTS = 'EXPORT_DOWNLOAD_ATTEMPTS';
    public static final String HTTP_HEADER_CORR_ID = 'HTTP_HEADER_CORR_ID';
    public static final String MAX_FILE_SIZE = 'MaxFileSize';
    public static final String NBF = 'nbf';
    public static final String NUMBER_OF_CHARACTERS_FOR_IDEOGRAM = 'NUMBER_OF_CHARACTERS_FOR_IDEOGRAM';
    public static final String NUMBER_OF_CHARACTERS_FOR_PHONOGRAM = 'NUMBER_OF_CHARACTERS_FOR_PHONOGRAM';
    public static final String RECORD_MIGRATION_CONTINUATION_TIMEOUT = 'RecordMigrationContinuationTimeout';
    public static final String REPORT_PAGE_SIZE = 'ReportPageSize';
    public static final String SYNC_BATCH_SIZE = 'SYNC_BATCH_SIZE';
    public static final String WEB_TO_LEAD_CAPTCHA_PRIVATE_KEY = 'WebToLeadCaptchaPrivateKey';
    public static final String WEB_TO_LEAD_CAPTCHA_PUBLIC_KEY = 'WebToLeadCaptchaPublicKey';
    public static final String WEB_TO_LEAD_SERVICE_ENDPOINT = 'WebToLeadServiceEndpoint';

    public static final String ENABLE_DUPLICATE_MANAGEMENT = 'ENABLE_DUPLICATE_MANAGEMENT';
    public static final String ENABLE_DETAILED_SYNC_LOGGING = 'ENABLE_DETAILED_SYNC_LOGGING';
    public static final String REPORT_REQUESTS_ATTEMPTS = 'REPORT_REQUESTS_ATTEMPTS';

    private final Map<String, MetadataSettingDTO> VALUE_INFO_BY_DEVELOPER_NAME = new Map<String, MetadataSettingDTO>{
        EXP => new SettingsService.MetadataSettingDTO(SettingsService.INPUT_TYPE, EXP),
        EXPORT_DOWNLOAD_ATTEMPTS => new SettingsService.MetadataSettingDTO(SettingsService.INPUT_TYPE, EXPORT_DOWNLOAD_ATTEMPTS),
        HTTP_HEADER_CORR_ID => new SettingsService.MetadataSettingDTO(SettingsService.INPUT_TYPE, HTTP_HEADER_CORR_ID),
        MAX_FILE_SIZE => new SettingsService.MetadataSettingDTO(SettingsService.INPUT_TYPE, MAX_FILE_SIZE),
        NBF => new SettingsService.MetadataSettingDTO(SettingsService.INPUT_TYPE, NBF),
        NUMBER_OF_CHARACTERS_FOR_IDEOGRAM => new SettingsService.MetadataSettingDTO(SettingsService.INPUT_TYPE, NUMBER_OF_CHARACTERS_FOR_IDEOGRAM),
        NUMBER_OF_CHARACTERS_FOR_PHONOGRAM => new SettingsService.MetadataSettingDTO(SettingsService.INPUT_TYPE, NUMBER_OF_CHARACTERS_FOR_PHONOGRAM),
        RECORD_MIGRATION_CONTINUATION_TIMEOUT => new SettingsService.MetadataSettingDTO(SettingsService.INPUT_TYPE, RECORD_MIGRATION_CONTINUATION_TIMEOUT),
        REPORT_PAGE_SIZE => new SettingsService.MetadataSettingDTO(SettingsService.INPUT_TYPE, REPORT_PAGE_SIZE),
        SYNC_BATCH_SIZE => new SettingsService.MetadataSettingDTO(SettingsService.INPUT_TYPE, SYNC_BATCH_SIZE),
        WEB_TO_LEAD_CAPTCHA_PRIVATE_KEY => new SettingsService.MetadataSettingDTO(SettingsService.INPUT_TYPE, WEB_TO_LEAD_CAPTCHA_PRIVATE_KEY),
        WEB_TO_LEAD_CAPTCHA_PUBLIC_KEY => new SettingsService.MetadataSettingDTO(SettingsService.INPUT_TYPE, WEB_TO_LEAD_CAPTCHA_PUBLIC_KEY),
        WEB_TO_LEAD_SERVICE_ENDPOINT => new SettingsService.MetadataSettingDTO(SettingsService.INPUT_TYPE, WEB_TO_LEAD_SERVICE_ENDPOINT),
        REPORT_REQUESTS_ATTEMPTS => new SettingsService.MetadataSettingDTO(SettingsService.INPUT_TYPE, REPORT_REQUESTS_ATTEMPTS)
    };

    private final Map<String, MetadataFlagDTO> FLAG_INFO_BY_DEVELOPER_NAME = new Map<String, MetadataFlagDTO>{
        ENABLE_DUPLICATE_MANAGEMENT => new SettingsService.MetadataFlagDTO(SettingsService.TOGGLE_TYPE, ENABLE_DUPLICATE_MANAGEMENT),
        ENABLE_DETAILED_SYNC_LOGGING => new SettingsService.MetadataFlagDTO(SettingsService.TOGGLE_TYPE, ENABLE_DETAILED_SYNC_LOGGING)
    };

    private List<InCountryValue__mdt> getCustomMetadataValues {
        get {
            if (getCustomMetadataValues == null) {
                getCustomMetadataValues = new CustomMetadataValueSelector()
                    .selectValueRecordByDeveloperNames(new List<String>(VALUE_INFO_BY_DEVELOPER_NAME.keySet()));
            }
            return getCustomMetadataValues;
        }
        set;
    }

    // private List<InCountryFlags__mdt> getCustomMetadataFlags {
    //     get {
    //         if (getCustomMetadataFlags == null) {
    //             getCustomMetadataFlags = (List<InCountryFlags__mdt>) new CustomMetadataFlagsSelector()
    //                 .selectValueRecordByDeveloperNames(new List<String>(FLAG_INFO_BY_DEVELOPER_NAME.keySet()));
    //         }
    //         return getCustomMetadataFlags;
    //     }
    //     set;
    // }

    // private String flagMetadataApiName {
    //     get {
    //         return InCountryFlags__mdt.SObjectType.getDescribe().getName();
    //     }
    //     set;
    // }

    private String valueMetadataApiName {
        get {
            return InCountryValue__mdt.SObjectType.getDescribe().getName();
        }
        set;
    }

    // public CustomMetadataDMLOperations setMetadataDMLOperationInstance(InCountryFlags__mdt metadataRecord) {
    //     String cmApiNameRecord = String.isNotBlank(metadataRecord.NamespacePrefix)
    //         ? flagMetadataApiName + '.' + metadataRecord.NamespacePrefix + '__' + metadataRecord.DeveloperName
    //         : flagMetadataApiName + '.' + metadataRecord.DeveloperName;

    //     CustomMetadataDMLOperations customMetadataDmlManagement = new CustomMetadataDMLOperations()
    //         .setCustomMetadata(cmApiNameRecord, metadataRecord.MasterLabel)
    //         .addCustomMetadataValue(InCountryFlags__mdt.IsEnabled__c.getDescribe().getName(), String.valueOf(metadataRecord.IsEnabled__c))
    //         .addCustomMetadataValue(InCountryFlags__mdt.Description__c.getDescribe().getName(), String.valueOf(metadataRecord.Description__c));

    //     return customMetadataDmlManagement;
    // }

    public CustomMetadataDMLOperations setMetadataDMLOperationInstance(InCountryValue__mdt metadataRecord) {
        String cmApiNameRecord = String.isNotBlank(metadataRecord.NamespacePrefix)
            ? valueMetadataApiName + '.' + metadataRecord.NamespacePrefix + '__' + metadataRecord.DeveloperName
            : valueMetadataApiName + '.' + metadataRecord.DeveloperName;

        CustomMetadataDMLOperations customMetadataDmlManagement = new CustomMetadataDMLOperations()
            .setCustomMetadata(cmApiNameRecord, metadataRecord.MasterLabel)
            .addCustomMetadataValue(InCountryValue__mdt.Value__c.getDescribe().getName(), String.valueOf(metadataRecord.Value__c));

        return customMetadataDmlManagement;
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

    // public void updateFlagSetting(String settingsString) {
    //     try {
    //         SettingsService.MetadataFlagDTO flagSetting = (SettingsService.MetadataFlagDTO)
    //             JSON.deserialize(
    //                 settingsString,
    //                 SettingsService.MetadataFlagDTO.class
    //             );

    //         this.updateFlagSetting(flagSetting);
    //     } catch (Exception ex) {
    //         throw new InCountryMetadataException('Bad attempt to generate new metadata');
    //     }
    // }

    public void updateSettings(SettingsService.MetadataResultDTO resultSettings) {
        for (SettingsService.MetadataSettingDTO wrapper : resultSettings.listSettings) {

            CustomMetadataDMLOperations customMetadataDmlManagement = setMetadataDMLOperationInstance(
                createInCountryValueSettingInstance(wrapper)
            );

            SettingsService.upsertMetadataRecord(customMetadataDmlManagement, wrapper.id == null);
        }
    }

    // public void updateFlagSetting(SettingsService.MetadataFlagDTO flagSettingWrapper) {
    //     CustomMetadataDMLOperations customMetadataDmlManagement = setMetadataDMLOperationInstance(
    //         createInCountryFlagsSettingInstance(flagSettingWrapper)
    //     );


        
    //     SettingsService.upsertMetadataRecord(customMetadataDmlManagement, flagSettingWrapper.id == null);
    // }

    // private Boolean validateSettings(SettingsService.MetadataResultDTO settingsTDO) {
    //     for (SettingsService.MetadataSettingDTO settingTDO : settingsTDO.listSettings) {
    //         if (
    //             settingTDO.developerName == REPORT_REQUESTS_ATTEMPTS
    //             && !validateSettingReportRequestsAttempts(settingTDO)
    //         ) {
    //             throw new InCountryMetadataException(
    //                 System.Label.PreferencesSettings_ValidationNumberValueRange.replace('{0}', '1').replace('{1}','50')
    //             );
    //         }
    //     }

    //     return true;
    // }

    // private Boolean validateSettingReportRequestsAttempts(SettingsService.MetadataSettingDTO settingTDO) {
    //     return Pattern.matches(REGEXP_REPORT_REQUESTS_ATTEMPTS, String.valueOf(settingTDO.value));
    // }

    // private InCountryFlags__mdt createInCountryFlagsSettingInstance(SettingsService.MetadataFlagDTO wrapper) {
    //     InCountryFlags__mdt inCountryFlag = wrapper.id != null
    //         ? ((CustomMetadataFlagsSelector) CustomMetadataFlagsSelector.newInstance()).selectValueRecordByDeveloperName(wrapper.developerName)
    //         : new InCountryFlags__mdt(
    //             DeveloperName = wrapper.developerName,
    //             MasterLabel = wrapper.label
    //         );

    //     inCountryFlag.IsEnabled__c = wrapper.value;
    //     inCountryFlag.Description__c = wrapper.description;

    //     return inCountryFlag;
    // }

    private InCountryValue__mdt createInCountryValueSettingInstance(SettingsService.MetadataSettingDTO wrapper) {
        InCountryValue__mdt inCountryValue = wrapper.id != null
            ? ((CustomMetadataValueSelector) CustomMetadataValueSelector.newInstance()).selectValueRecordByDeveloperName(wrapper.developerName)
            : new InCountryValue__mdt(
                DeveloperName = wrapper.developerName,
                MasterLabel = wrapper.label
            );

        inCountryValue.Value__c = wrapper.value;

        return inCountryValue;
    }

    public SettingsService.MetadataResultDTO prepareSettings() {
        SettingsService.MetadataResultDTO metadataResult = new SettingsService.MetadataResultDTO();

        try {
            metadataResult = this.prepareSettings(metadataResult);
            metadataResult.isOk = true;
        } catch (Exception ex) {
            metadataResult.message = ex.getMessage();
        }

        return metadataResult;
    }

    public SettingsService.MetadataResultDTO prepareSettings(SettingsService.MetadataResultDTO metadataResult) {
        createMetadataValueWrappers();
        //createMetadataFlagWrappers();

        metadataResult.listSettings = new List<SettingsService.MetadataSettingDTO>();
        metadataResult.listSettings.addAll(VALUE_INFO_BY_DEVELOPER_NAME.values());

        metadataResult.flagSettings = new List<SettingsService.MetadataFlagDTO>();
        metadataResult.flagSettings.addAll(FLAG_INFO_BY_DEVELOPER_NAME.values());

        return metadataResult;
    }

    private void createMetadataValueWrappers() {
        for (InCountryValue__mdt value : getCustomMetadataValues) {
            MetadataSettingDTO valueWrapper = VALUE_INFO_BY_DEVELOPER_NAME.get(value.DeveloperName);

            if (valueWrapper != null) {
                valueWrapper.setData(value);
            }
        }
    }

    // private void createMetadataFlagWrappers() {
    //     for (InCountryFlags__mdt value: getCustomMetadataFlags) {
    //         MetadataFlagDTO valueWrapper = FLAG_INFO_BY_DEVELOPER_NAME.get(value.DeveloperName);

    //         if (valueWrapper != null) {
    //             valueWrapper.setData(value);
    //         }
    //     }
    // }

    public static SettingsService.ISettingsService newInstance() {
        return (SettingsService.ISettingsService) Application.Service.newInstance(
            SettingsService.ISettingsService.class
        );
    }

    private static void upsertMetadataRecord(CustomMetadataDMLOperations customMetadata, Boolean insertRecord) {
        if (insertRecord) {
            customMetadata.createEndpointMetadataRecord();
        } else {
            customMetadata.updateEndpointMetadataRecord();
        }
    }

    @JsonAccess(Serializable='always' Deserializable='always')
    public class MetadataResultDTO {
        @AuraEnabled public Boolean isOk = false;
        @AuraEnabled public String message;
        @AuraEnabled public List<MetadataFlagDTO> flagSettings;
        @AuraEnabled public List<MetadataSettingDTO> listSettings;
    }

    public class MetadataSettingDTO {
        @AuraEnabled public Id id;
        @AuraEnabled public String label;
        @AuraEnabled public String type;
        @AuraEnabled public String description;
        @AuraEnabled public String developerName;
        @AuraEnabled public String value = '';

        public MetadataSettingDTO(String type, String developerName) {
            this.type = type;
            this.developerName = developerName;
        }

        public void setData(InCountryValue__mdt value) {
            this.id = value.Id;
            this.value = value.Value__c;
        }
    }

    public class MetadataFlagDTO {
        @AuraEnabled public Id id;
        @AuraEnabled public String label;
        @AuraEnabled public String type;
        @AuraEnabled public String description;
        @AuraEnabled public String developerName;
        @AuraEnabled public Boolean value;

        public MetadataFlagDTO(String type, String developerName) {
            this.type = type;
            this.developerName = developerName;
        }

        public void setData(InCountryFlags__mdt value) {
            this.id = value.Id;
            this.value = value.IsEnabled__c;
        }

    }

}