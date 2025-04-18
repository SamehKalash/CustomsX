# CustomsX
Smart Customs Clearance Facilitator 

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/SamehKalash/CustomsX/
   ```
2. Navigate to the project directory:
   ```bash
   cd customsx
   ```
3. Clean and Build Application:
   ```bash
   flutter clean
   flutter run
   ```

## Contribution
1. Fork the repository.
2. Create a new branch for your feature/bugfix:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Add your message here"
   ```
4. Push the branch:
   ```bash
   git push origin feature-name
   ```
5. Open a Pull Request.

## Need to be done 
### Electronic customs payments for 
Should be a direct payments where you select the Type of Payment which one be one of these payments 

	1. simplified customs declaration
	2. Customs declaration 
	3. Temporary Storage
	4. Transport Barcode
	5. Fine
	6. Expertise
After selecting one of the Type of payment there should also be document number to search for the payment need to be done 

### Calculate the customs fees (duties) yourself
#### Transportation Vehicles 
You should select Type of Vehicle which is standard as **Passenger Car** then select the **Engine Type** which should be one of the following 
1. Petrol
2. Diesel
3. Gas
4. Hybrid-Gasoline
5. Hybrid-Diesel
6. Electric

**Invoice value (USD)** , **Transportation costs (USD)** and **Other expenses (USD)** should be mentioned, In addition to the **Engine Capacity (cm3)** , **Data of production** ( The date of production must be indicated to determine the **amount of payment** for the "Disposal fee" of the vehicles and the rate of import customs duty in accordance with the HS code) and last not least the **About the country of origin (production) and the country of the sender** () should be selected whether its Other countries or Produced in the country with which a free trade agreement has been concluded and imported from there.

Based on these info, Results showed be shown to the User in **EGP** & They are shown as the following  1 USD =  51.1917 EGP

- Import customs duty
- Value added tax (VAT)
- Customs fees for customs clearance of goods
- Excise tax
- Customs fees for issuing certificates
- Electronic customs service fee
- VAT on electronic customs services
- Disposal fee
- Conducting customs expertise fee
- Certificate of compliance with standards fee

It should show the user Total customs payments 
* Customs value = (Invoice value +Transportation costs + Other expenses) * USD exchange rate

#### Other Goods

**TO BE MENTIONED**


#### Note must be mentioned
"Attention! Customs payments are calculated based on the entered data. During customs clearance, depending on the method of determining the customs value of goods, there may be differences in the amount of customs duties."



### FAQ / Help Center
### Smart Bot
