/**
 * @description       : 
 * @author            : Riley Meyer
 * @group             : 
 * @last modified on  : 05-19-2024
 * @last modified by  : Riley Meyer
**/
@IsTest
private class LeadTriggerHandlerTest {

    @IsTest
    static void testHandleTitleNormalization() {
        // Load Test Data
        List<Lead> leads = new List<Lead>();
        leads.add(new Lead(FirstName = 'David', LastName = 'Bolding', Company = 'Bolding Metals', Title = 'vp'));
        leads.add(new Lead(FirstName = 'Warren', LastName = 'Walters', Company = 'CCA', Title = 'v.p.'));
        leads.add(new Lead(FirstName = 'Chase', LastName = 'BigDawg', Company = 'BigDawg Rocks', Title = 'vice president'));
        leads.add(new Lead(FirstName = 'Brooks', LastName = 'Wizard', Company = 'Wizard School', Title = 'mgr'));
        leads.add(new Lead(FirstName = 'Oxana', LastName = 'Suvorova', Company = 'Suvorova Schools', Title = 'manage'));
        leads.add(new Lead(FirstName = 'John', LastName = 'George', Company = 'George Elite', Title = 'head of department'));
        leads.add(new Lead(FirstName = 'Navid', LastName = 'Mudassir', Company = 'M.U.D.', Title = 'exec'));
        leads.add(new Lead(FirstName = 'Raghavendra', LastName = 'Yadavalli', Company = 'R.Y.', Title = 'chief'));
        leads.add(new Lead(FirstName = 'Tony', LastName = 'Kirumba', Company = 'Tony\'s Turtles', Title = 'head'));
        leads.add(new Lead(FirstName = 'Ariel', LastName = 'T.', Company = 'Under the Sea', Title = 'assist'));
        leads.add(new Lead(FirstName = 'Dallas', LastName = 'Bailey', Company = 'Bailey Tea', Title = 'deputy'));
        leads.add(new Lead(FirstName = 'Tyler', LastName = 'Riden', Company = 'Rock n Riden', Title = 'jr'));
        leads.add(new Lead(FirstName = 'Riley', LastName = 'Meyer', Company = 'Developer Futures', Title = 'developer'));

        // Run Test
        Test.startTest();
        Database.insert(leads, AccessLevel.SYSTEM_MODE);
        Test.stopTest();

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

        System.assertEquals(3, vicePresidents.size(), 'A Lead Title was not correctly updated to Vice President');
        for (Lead vp : vicePresidents) {
            System.assertEquals('Vice President', vp.Title, 'A Lead Title was not correclty set to Vice President');
        }
        System.assertEquals(3, managers.size(), 'A Lead Title was not correctly updated to Manager');
        for (Lead mgr : managers) {
            System.assertEquals('Manager', mgr.Title, 'A Lead Title was not correclty set to Manager');
        }
        System.assertEquals(3, executives.size(), 'A Lead Title was not correctly updated to Executive');
        for (Lead exec : executives) {
            System.assertEquals('Executive', exec.Title, 'A Lead Title was not correclty set to Executive');
        }
        System.assertEquals(3, assistants.size(), 'A Lead Title was not correctly updated to Assistant');
        for (Lead assit : assistants) {
            System.assertEquals('Assistant', assit.Title, 'A Lead Title was not correclty set to Assistant');
        }
        System.assertEquals(1, otherTitles.size(), 'A Lead Title was incorrectly updated when it should have remained');
        for (Lead other : otherTitles) {
            System.assertEquals('developer', other.Title, 'A Lead Title was incorrectly updated when it should have remained');
        }
    }

}