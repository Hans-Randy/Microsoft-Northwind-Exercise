ALTER PROCEDURE pr_GetOrderSummary @StartDate DATETIME, @EndDate DATETIME, @EmployeeID INT, @CustomerID NVARCHAR(5)
AS
    SELECT
        EmployeeFullName = Employees.TitleOfCourtesy + ' ' + Employees.FirstName + ' ' + Employees.LastName
        , [Shipper CompanyName] = Shippers.CompanyName
        , [Customer CompanyName] = Customers.CompanyName
        , NumberOfOrders = COUNT(DISTINCT Orders.OrderID) 
        , [Date] = Orders.OrderDate
        , TotalFreightCost = SUM(Orders.Freight)
        , NumberOfDifferentProducts = COUNT(DISTINCT OrderDetails.ProductID)
        , TotalOrderValue = SUM((OrderDetails.UnitPrice * OrderDetails.Quantity) - OrderDetails.Discount)
    FROM 
        Orders WITH (NOLOCK)
    INNER JOIN 
        Employees WITH (NOLOCK) ON Orders.EmployeeID = Employees.EmployeeID
    INNER JOIN 
        Customers WITH (NOLOCK) ON Orders.CustomerID = Customers.CustomerID
    INNER JOIN 
        Shippers WITH (NOLOCK) ON Orders.ShipVia = Shippers.ShipperID
    INNER JOIN
        [Order Details] OrderDetails WITH (NOLOCK)  ON Orders.OrderID = OrderDetails.OrderID
    WHERE
        Orders.OrderDate BETWEEN @StartDate AND @EndDate
        AND Employees.EmployeeID = ISNULL(@EmployeeID, Employees.EmployeeID)
        AND Customers.CustomerID = ISNULL(@CustomerID, Customers.CustomerID)
    GROUP BY
        Orders.OrderDate
        , Employees.TitleOfCourtesy
        , Employees.FirstName
        , Employees.LastName
        , Customers.CompanyName
        , Shippers.CompanyName
GO


