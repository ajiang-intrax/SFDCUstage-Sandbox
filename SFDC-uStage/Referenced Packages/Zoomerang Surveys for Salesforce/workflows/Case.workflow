<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ZMG_Send_Survey_Email_to_Case_Contact_after_Case_Closed</fullName>
        <description>ZMG_Send Survey Email to Case Contact after Case Closed</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Zoomerang_Templates/ZMG_Case_Closed_Survey_Template</template>
    </alerts>
    <rules>
        <fullName>ZMG_Case Closed Survey Completed</fullName>
        <actions>
            <name>ZMG_Survey_Completed_by_Case_Contact</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ZMG_Survey_Completed__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Task created when Zoomerang Survey is completed related to a closed Case.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ZMG_Case Closed Survey Sent</fullName>
        <actions>
            <name>ZMG_Survey_Sent_to_Case_Contact</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Email sent to Case Contact with Zoomerang Survey when Case is Closed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>ZMG_Survey_Completed_by_Case_Contact</fullName>
        <assignedToType>owner</assignedToType>
        <description>Copy and paste this link to view the Survey:
[Insert public survey URL here for reference]</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Survey Completed : &apos;Customer Satisfaction with Customer Service&apos;</subject>
    </tasks>
    <tasks>
        <fullName>ZMG_Survey_Sent_to_Case_Contact</fullName>
        <assignedToType>owner</assignedToType>
        <description>Copy and paste this link to view the Survey:
[Insert public survey URL here for reference]</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Survey Sent : &apos;Customer Satisfaction with Customer Service&apos;</subject>
    </tasks>
</Workflow>
