object:Configuration__c,  Name:QUOTE_PAGE_3, STRING_VALUE__C:createquotestep3 
object:Configuration__c,  Name:QUOTE_PAGE_2, STRING_VALUE__C:createquotestep2 
object:Configuration__c,  Name:PRODUCT_OBJECTNAME, STRING_VALUE__C:Product__c, Description__c:The name of the object that has to be searched for
object:Configuration__c,  Name:NO_OF_DECIMALS_FOR_CURRENCY_VALUES, NUMBER_VALUE__C:3, Field_Type__c:Number, Description__c:Enter the number of decimals (precision) for all your currency values. Currency values will be rounded to the specified number of decimals.
object:Configuration__c,  Name:CALCULATION_PRECISION, Field_Type__c:String, Description__c:Mention if you want to ROUND_UP or ROUND_DOWN the quote and order totals. If total is 46.70 ROUND_UP will make it 47 and ROUND_DOWN will make it 46. Leaving this blank will leave the total unchanged.
object:Configuration__c,  Name:PRODUCT_SEARCH_LIMIT, NUMBER_VALUE__C:20, Field_Type__c:Number, Description__c:The number of records entered during instant search in page 2 of quote and order wizards. Lower numbers will provide you quicker results
object:Configuration__c,  Name:PRODUCT_ORDERFIELD, STRING_VALUE__C:Name, Field_Type__c:String, Description__c:The field order for the results from the instant search in page 2 of quote and order wizards. Use field api names of Invoice It Product object separated by commas.
object:Configuration__c,  Name:TYPE_OF_PACKAGE, STRING_VALUE__C:STANDALONE 
object:Configuration__c,  Name:PRODUCT_DISPLAYFIELDS, Field_Type__c:String, Description__c:If you need additional Invoice IT Product fields to be displayed on the instant search results apart from those searched for mention them here. Use field api names separated by commas.
object:Configuration__c,  Name:INVOICE_GROUP_CRITERIA, STRING_VALUE__C:ONE_INVOICE_PER_ORDER, Field_Type__c:String, Description__c:Define if you want to generate ONE_INVOICE_PER_ORDER or ONE_INVOICE_PER_ACCOUNT
object:Configuration__c,  Name:ORDER_PAGE_3, STRING_VALUE__C:createjobstep3 
object:Configuration__c,  Name:ORDER_STATUS_FOR_INVOICING, Field_Type__c:String, Description__c:Define the Order status field that determines if it has to be picked for invoicing. Say Delivered
object:Configuration__c,  Name:DEFAULT_CURRENCY, STRING_VALUE__C:GBP, Field_Type__c:String, Description__c:Mention the ISO code of your default currency here. Say GBP
object:Configuration__c,  Name:QUOTE_VALIDITY_PERIOD, NUMBER_VALUE__C:15, Field_Type__c:Number, Description__c:The default number of days your quote is valid from the created date.
object:Configuration__c,  Name:ORDER_PAGE_2, STRING_VALUE__C:createjobstep2 
object:Configuration__c,  Name:CHARGE_STATUS_FOR_INVOICING, Field_Type__c:String, Description__c:Define the Order Rate Plan Charge status field that determines if it has to be picked for invoicing. Say Delivered
object:Configuration__c,  Name:INVOICE_NO_OF_DAYS_TILL_DUE_DATE, NUMBER_VALUE__C:15, Field_Type__c:Number, Description__c:The number of days when your invoice is due from the invoice date
object:Configuration__c,  Name:TAX_CALCULATION_BASED_ON, STRING_VALUE__C:Shipping Contact, Field_Type__c:String, Description__c:Should the tax and vat be calculated based on the Shipping address or Billing address. Allowed values are Shipping Contact or Billing Contact
object:Configuration__c,  Name:USE_SERVICE_START_DATE_FOR_INVOICE, Field_Type__c:Boolean, Description__c:Align Order Service Start Date to Order Date? Leave this un-checked if normally your service start dates are different to the order date., Boolean_Value__c:True 
object:Configuration__c,  Name:DISCOUNT_BY_VALUE_OR_PERCENTAGE, Field_Type__c:String, Description__c:Apply discounts by value or by percentage. Options are APPLY_DISCOUNT_BY_VALUE and APPLY_DISCOUNT_BY_PERCENTAGE, STRING_VALUE__C:APPLY_DISCOUNT_BY_PERCENTAGE 
object:Configuration__c,  Name:AUTOMATE_PAYMENT_ALLOCATION, Field_Type__c:Boolean, Description__c:Should the payments be allocated against the pending invoices automatically?, Boolean_Value__c:True
object:Configuration__c,  Name:ORDER_DISCOUNT_CODE_FIELD, Field_Type__c:String, Description__c:Default field on Order that holds the discount codes (Use API name), STRING_VALUE__C:Discount_Code__c
object:Configuration__c,  Name:QUOTE_DISCOUNT_CODE_FIELD, Field_Type__c:String, Description__c:Default field on Quote that holds the discount codes (Use API name), STRING_VALUE__C:Discount_Code__c
object:Configuration__c,  Name:DEFAULT_PAYMENT_TERMS, Field_Type__c:String, STRING_VALUE__C:Due On Receipt, Description__c:Default payment terms used on account if account payment terms is null
object:Configuration__c,  Name:ALIGN_DATES_OF_ORDER_TO_PRODUCTS, Description__c:Align service start dates of order lines to that of order?, Field_Type__c:Boolean, Boolean_Value__c:True
object:Configuration__c,  Name:CAN_REFUND_CHARGES_DURING_ADJUSTMENTS, Field_Type__c:Boolean, Description__c:Do you want to refund for services that are paid for but cancelled mid-way?, Boolean_Value__c:False
object:Configuration__c,  Name:DEFAULT_QUANTITY_IN_WIZARDS, Field_Type__c:Number, Description__c:Default Quantity when adding products to Quote/Order wizard?, NUMBER_VALUE__C:1
object:Payment_Terms__c,  Name:Due On Receipt, Number_Of_Days__c:0
object:Payment_Terms__c,  Name:Net 30, Number_Of_Days__c:30
object:Payment_Terms__c,  Name:Net 45, Number_Of_Days__c:45
object:Payment_Terms__c,  Name:Net 60, Number_Of_Days__c:60