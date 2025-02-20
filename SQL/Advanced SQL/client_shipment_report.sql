-- from SaleHeader: get ReceiptNo to link with SaleDetail and SaleDate
SELECT [ReceiptNo]
      ,[SaleDate]
      ,[StaffId]
      ,[ShopNo]
      ,[CustNo]
      ,[SaleTotal]
      ,[Cancelled]
  INTO #SaleHeader
  FROM [JCS].[dbo].[SaleHeader]
  WHERE [SaleDate] BETWEEN '2004-01-01' AND '2024-08-31'
  ORDER BY [SaleDate] DESC;

-- from SaleDetail: get ReceiptNo and Code to link with Stock
SELECT [ReceiptNo]
      ,[Code]
      ,[Description]
      ,[SoldForPriceEach]
      ,[LineTotal]
  INTO #SaleDetail
  FROM [JCS].[dbo].[SaleDetail];

-- join the above 2
  SELECT *
  FROM #SaleHeader h
  LEFT JOIN #SaleDetail d
  ON h.[ReceiptNo] = d.[ReceiptNo]
  ORDER BY h.[SaleDate] DESC

-- get cubism stock
  SELECT [StockNo]
      ,[StockTypeId]
      ,[DesignNo]
      ,[SellingPrice]
      ,[SaleDate]
      ,[CollectionId]
      ,[Description]
  INTO #CubStock
  FROM [JCS].[dbo].[Stock]
  WHERE [CollectionId] = 'CUBSM'
  AND ([DesignNo] IN ('CCWB 123', 'CCBC 101') OR [DesignNo] LIKE 'CCL 102%' OR [DesignNo] LIKE 'CCL 381%' OR [DesignNo] LIKE 'CCL 121%' OR [StockTypeId] = 'DIRNG');

-- get receipt no and stock no
  select d.[ReceiptNo], d.[Code], c.[Description], d.[SoldForPriceEach], d.[LineTotal], c.[DesignNo]
  into #SDCS
  from #SaleDetail d
  join #CubStock c
  on d.[Code] = c.[StockNo]

-- link the above and SaleHeader
  select h.*, s.[Description], s.[LineTotal], s.[DesignNo]
  into #SHSDCS
  from #SaleHeader h
  join #SDCS s on h.[ReceiptNo] = s.[ReceiptNo]
  order by h.[SaleDate] desc

-- get customers
SELECT [CustNo]
      ,[VIP]
      ,[Name]
      ,[Surname]
      ,[State]
      ,[Postcode]
      ,[StaffId]
      ,[CustomerTotalSpend]
into #Customer
FROM [JCS].[dbo].[Customer]

-- final report - join with customers
select * from #SHSDCS s join #Customer c on s.[CustNo] = c.[CustNo]
order by s.[SaleDate] desc

-- Step 1: Extract recent shipment records into a temporary table
SELECT [ShipmentID],  
       [ShipmentDate],  
       [StaffID],  
       [Destination],  
       [CustomerID],  
       [TotalWeight]  
INTO #RecentShipments  
FROM [LogisticsDB].[dbo].[ShipmentHeader]  
WHERE [ShipmentDate] BETWEEN '2024-01-01' AND '2024-08-31'  
ORDER BY [ShipmentDate] DESC;  

-- Step 2: Extract shipment details (linking shipment ID with products)
SELECT [ShipmentID],  
       [ProductCode],  
       [ProductDescription],  
       [Quantity],  
       [UnitPrice],  
       [TotalPrice]  
INTO #ShipmentDetails  
FROM [LogisticsDB].[dbo].[ShipmentDetails];  

-- Step 3: Join recent shipments with shipment details  
SELECT s.*, d.[ProductDescription], d.[TotalPrice]  
INTO #ShipmentSummary  
FROM #RecentShipments s  
LEFT JOIN #ShipmentDetails d  
ON s.[ShipmentID] = d.[ShipmentID]  
ORDER BY s.[ShipmentDate] DESC;  

-- Step 4: Retrieve customer data  
SELECT [CustomerID],  
       [CustomerName],  
       [Region],  
       [TotalSpent]  
INTO #CustomerData  
FROM [LogisticsDB].[dbo].[Customers];  

-- Step 5: Final report - Join shipment summary with customer details  
SELECT s.*, c.[CustomerName], c.[Region], c.[TotalSpent]  
FROM #ShipmentSummary s  
LEFT JOIN #CustomerData c  
ON s.[CustomerID] = c.[CustomerID]  
ORDER BY s.[ShipmentDate] DESC;