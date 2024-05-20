/**
 * @description       : 
 * @author            : Riley Meyer
 * @group             : 
 * @last modified on  : 05-19-2024
 * @last modified by  : Riley Meyer
**/
@IsTest
private class LeadTriggerHandlerTest {

    @TestSetup
    static void makeData(){
        // List<Contact> contacts = new List<Contact>();
        // contacts.add(new Contact(FirstName='David', LastName='Bolding', Email='d.bolding@metals.com'));
        // contacts.add(new Contact(FirstName='Warren', LastName='Walters', Email='walterstest@CCA.com'));
        // contacts.add(new Contact(FirstName='Chase', LastName='BigDawg', Email='c.brammer@rcks.com'));
        // contacts.add(new Contact(FirstName='Riley', LastName='Meyer'));

        // Database.insert(contacts, AccessLevel.SYSTEM_MODE);

        List<Lead> leads = new List<Lead>();
        leads.add(new Lead(FirstName = 'David', LastName = 'Bolding', Company = 'Bolding Metals', Title = 'vp', Industry='Manufacturing', LeadSource='Web', Email='d.bolding@metals.com'));
        leads.add(new Lead(FirstName = 'Warren', LastName = 'Walters', Company = 'CCA', Title = 'v.p.', Industry='Technology', LeadSource='Web', Phone='123-456-7890'));
        leads.add(new Lead(FirstName = 'Chase', LastName = 'BigDawg', Company = 'BigDawg Rocks', Title = 'vice president', Industry='Construction', LeadSource='Purchased List', Email='c.bigdawg@rcks.com', Phone='456-654-9874'));
        leads.add(new Lead(FirstName = 'Brooks', LastName = 'Wizard', Company = 'Wizard School', Title = 'mgr', Industry='Education', LeadSource='Purchased List', Email='b.magic@potions.com'));
        leads.add(new Lead(FirstName = 'Oxana', LastName = 'Suvorova', Company = 'Suvorova Schools', Title = 'manage', Industry='Technology', LeadSource='Purchased List', Email='o.suvorova@schools.com'));
        leads.add(new Lead(FirstName = 'John', LastName = 'George', Company = 'George Elite', Title = 'head of department', Industry='Apparel', LeadSource='Purchased List', Email='j.george@elite.com'));
        leads.add(new Lead(FirstName = 'Navid', LastName = 'Mudassir', Company = 'M.U.D.', Title = 'exec', Industry='Technology', LeadSource='Web', Email='n.mudassir@mud.com'));
        leads.add(new Lead(FirstName = 'Raghavendra', LastName = 'Yadavalli', Company = 'R.Y.', Title = 'chief', Industry='Utilities', LeadSource='Purchased List', Email='r.yadavalli@ry.com'));
        leads.add(new Lead(FirstName = 'Tony', LastName = 'Kirumba', Company = 'Tony\'s Turtles', Title = 'head', Industry='Retail', LeadSource='Purchased List', Email='t.kirumba@turtlesrule.com'));
        leads.add(new Lead(FirstName = 'Ariel', LastName = 'T.', Company = 'Under the Sea', Title = 'assist', Industry='Hospitality', LeadSource='Web', Email='a.t@underwater.com', Phone='654-321-5823'));
        leads.add(new Lead(FirstName = 'Dallas', LastName = 'Bailey', Company = 'Bailey Tea', Title = 'deputy', Industry='Retail', LeadSource='Phone Inquiry', Email='d.bailey@teatime.com'));
        leads.add(new Lead(FirstName = 'Tyler', LastName = 'Riden', Company = 'Rock n Riden', Title = 'jr', Industry='Construction', LeadSource='Partner Referral', Email='t.riden@rock4life.com'));
        leads.add(new Lead(FirstName = 'Riley', LastName = 'Meyer', Company = 'Developer Futures', Title = 'developer', Industry='Technology', LeadSource='Web', Email='r.meyer@dev.com', Phone='987-654-3210'));

        Database.insert(leads, AccessLevel.SYSTEM_MODE);
    }

    @IsTest
    static void testHandleTitleNormalization() {

        // Check Results
        List<Lead> titleUpdates = new List<Lead>([SELECT Id, FirstName, LastName, Company, Title
                                                    FROM Lead]);
        List<Lead> vicePresidents = new List<Lead>();
        List<Lead> managers = new List<Lead>();
        List<Lead> executives = new List<Lead>();
        List<Lead> assistants = new List<Lead>();
        List<Lead> otherTitles = new List<Lead>();
        for (Lead ld : titleUpdates) {
            if (ld.Title == 'Vice President') {
                vicePresidents.add(ld);
            } else if (ld.Title == 'Manager') {
                managers.add(ld);
            } else if (ld.Title == 'Executive') {
                executives.add(ld);
            } else if (ld.Title == 'Assistant') {
                assistants.add(ld);
            } else {
                otherTitles.add(ld);
            }
        }

        System.assertEquals(3, vicePresidents.size(), 'A Lead Title was not correctly set to Vice President');
        for (Lead vp : vicePresidents) {
            System.assertEquals('Vice President', vp.Title, 'A Lead Title was not correclty set to Vice President');
        }
        System.assertEquals(3, managers.size(), 'A Lead Title was not correctly set to Manager');
        for (Lead mgr : managers) {
            System.assertEquals('Manager', mgr.Title, 'A Lead Title was not correclty set to Manager');
        }
        System.assertEquals(3, executives.size(), 'A Lead Title was not correctly set to Executive');
        for (Lead exec : executives) {
            System.assertEquals('Executive', exec.Title, 'A Lead Title was not correclty set to Executive');
        }
        System.assertEquals(3, assistants.size(), 'A Lead Title was not correctly set to Assistant');
        for (Lead assit : assistants) {
            System.assertEquals('Assistant', assit.Title, 'A Lead Title was not correclty set to Assistant');
        }
        System.assertEquals(1, otherTitles.size(), 'A Lead Title was incorrectly set when it should have remained');
        for (Lead other : otherTitles) {
            System.assertEquals('developer', other.Title, 'A Lead Title was incorrectly set when it should have remained');
        }

        Id devId;
        for (Lead dev : otherTitles) {
                dev.Title = 'vice president';
                devId = dev.Id;
        }

        Database.update(otherTitles, AccessLevel.SYSTEM_MODE);
        List<Lead> otherTitlesUpdated = new List<Lead>([SELECT Id, Title 
                                                        FROM Lead
                                                        WHERE Id = :devId]);
        for (Lead other : otherTitlesUpdated) {
            System.assertEquals('Vice President', other.Title, 'A Lead Title was incorrectly updated during an update DML operation');
        }
    }

    @IsTest
    static void testHandleAutoLeadScoring() {
        // Check Results
        List<Lead> scoreUpdates = new List<Lead>([SELECT Id, FirstName, LastName, Lead_Score__c, LeadSource, Email, Phone, Industry
                                                    FROM Lead
                                                    ORDER BY Lead_Score__c DESC]);
        for (Lead ld : scoreUpdates) {
            if (ld.Industry=='Technology' && ld.Phone != null && ld.LeadSource == 'Web' && ld.Email != null) {
                System.assertEquals(18, ld.Lead_Score__c, 'Lead Score should have been 18');
            } else if(ld.Industry=='Technology' && ld.Phone != null) {
                System.assertEquals(15, ld.Lead_Score__c, 'Lead Score should have been 15');
            } else if(ld.Industry=='Technology' && ld.LeadSource == 'Web' && ld.Email != null) {
                System.assertEquals(13, ld.Lead_Score__c, 'Lead Score should have been 13');
            } else if (ld.Industry=='Technology') {
                System.assertEquals(10, ld.Lead_Score__c, 'Lead Score should have been 10');
            } else if (ld.Phone != null && ld.LeadSource == 'Web' && ld.Email != null) {
                System.assertEquals(8, ld.Lead_Score__c, 'Lead Score should have been 8');
            } else if (ld.Phone != null) {
                System.assertEquals(5, ld.Lead_Score__c, 'Lead Score should have been 5');
            } else if (ld.LeadSource == 'Web' && ld.Email != null) {
                System.assertEquals(3, ld.Lead_Score__c, 'Lead Score should have been 3');
            } else {
                System.assertEquals(0, ld.Lead_Score__c, 'Lead Score should have been 0');
            }
        }

        for (Lead ld : scoreUpdates) {
            if (ld.Phone != null) {
                ld.Phone = null;
            }
            if (ld.Email != null) {
                ld.Email = null;
            }
        }
        Database.update(scoreUpdates, AccessLevel.SYSTEM_MODE);
        List<Lead> scoresRoundTwo = new List<Lead>([SELECT Id, FirstName, LastName, Lead_Score__c, LeadSource, Email, Phone, Industry
                                                    FROM Lead
                                                    ORDER BY Lead_Score__c DESC]);
        for (Lead ld : scoresRoundTwo) {
            if (ld.Industry=='Technology' && ld.Phone != null && ld.LeadSource == 'Web' && ld.Email != null) {
                System.assertEquals(18, ld.Lead_Score__c, 'Lead Score should have been 18');
            } else if(ld.Industry=='Technology' && ld.Phone != null) {
                System.assertEquals(15, ld.Lead_Score__c, 'Lead Score should have been 15');
            } else if(ld.Industry=='Technology' && ld.LeadSource == 'Web' && ld.Email != null) {
                System.assertEquals(13, ld.Lead_Score__c, 'Lead Score should have been 13');
            } else if (ld.Industry=='Technology') {
                System.assertEquals(10, ld.Lead_Score__c, 'Lead Score should have been 10');
            } else if (ld.Phone != null && ld.LeadSource == 'Web' && ld.Email != null) {
                System.assertEquals(8, ld.Lead_Score__c, 'Lead Score should have been 8');
            } else if (ld.Phone != null) {
                System.assertEquals(5, ld.Lead_Score__c, 'Lead Score should have been 5');
            } else if (ld.LeadSource == 'Web' && ld.Email != null) {
                System.assertEquals(3, ld.Lead_Score__c, 'Lead Score should have been 3');
            } else {
                System.assertEquals(0, ld.Lead_Score__c, 'Lead Score should have been 0');
            }
        }
    }

    @IsTest
    static void testHandleLeadAutoConvert() {
        List<Lead> convertedLeads = new List<Lead>([SELECT Id, IsConverted
                                                    FROM Lead
                                                    WHERE IsConverted = TRUE]);
        System.assertEquals(0, convertedLeads.size(), 'Too many Leads were auto converted');

        // Test.startTest();
        // Contact contactToInsert = new Contact(FirstName='Riley', LastName='Meyer', Email='riley.meyer@orion.com');
        // Database.insert(contactToInsert, AccessLevel.SYSTEM_MODE);

        // List<Lead> leadsToUpdate = new List<Lead>([SELECT Id, Email, IsConverted
        //                                                         FROM Lead
        //                                                         WHERE Email = 'r.meyer@dev.com']);
        // System.debug('BEFORE UDPATE::::: ' + leadsToUpdate);
        // for (Lead ld : leadsToUpdate) {
        //     ld.Email = 'riley.meyer@orion.com';
        // }
        // Database.update(leadsToUpdate, AccessLevel.SYSTEM_MODE);
        // System.debug('AFTER UPDATE:::::: ' + leadsToUpdate);
        // Test.stopTest();

        // List<Lead> convertedLeadsTwo = new List<Lead>([SELECT Id, IsConverted
        //                                             FROM Lead
        //                                             WHERE IsConverted = TRUE]);
        // System.assertEquals(1, convertedLeadsTwo.size(), 'Too many Leads were auto converted');
    }

}