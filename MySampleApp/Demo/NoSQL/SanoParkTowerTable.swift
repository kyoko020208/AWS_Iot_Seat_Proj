//
//  SanoParkTowerTable.swift
//  MySampleApp
//
//
// Copyright 2017 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.10
//

import Foundation
import UIKit
import AWSDynamoDB
import AWSMobileHubHelper

class SanoParkTowerTable: NSObject, Table {
    
    var tableName: String
    var partitionKeyName: String
    var partitionKeyType: String
    var sortKeyName: String?
    var sortKeyType: String?
    var model: AWSDynamoDBObjectModel
    var indexes: [Index]
    var orderedAttributeKeys: [String] {
        return produceOrderedAttributeKeys(model)
    }
    var tableDisplayName: String {

        return "Sano-Park-Tower"
    }
    
    override init() {

        model = SanoParkTower()
        
        tableName = model.classForCoder.dynamoDBTableName()
        partitionKeyName = model.classForCoder.hashKeyAttribute()
        partitionKeyType = "String"
        indexes = [

            SanoParkTowerPrimaryIndex(),
        ]
        if let sortKeyNamePossible = model.classForCoder.rangeKeyAttribute?() {
            sortKeyName = sortKeyNamePossible
            sortKeyType = "String"
        }
        super.init()
    }
    
    /**
     * Converts the attribute name from data object format to table format.
     *
     * - parameter dataObjectAttributeName: data object attribute name
     * - returns: table attribute name
     */

    func tableAttributeName(_ dataObjectAttributeName: String) -> String {
        return SanoParkTower.jsonKeyPathsByPropertyKey()[dataObjectAttributeName] as! String
    }
    
    func getItemDescription() -> String {
        let hashKeyValue = "demo-key-3"
        let rangeKeyValue = "demo-timestamp-500000"
        return "Find Item with key = \(hashKeyValue) and timestamp = \(rangeKeyValue)."
    }
    
    func getItemWithCompletionHandler(_ completionHandler: @escaping (_ response: AWSDynamoDBObjectModel?, _ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        objectMapper.load(SanoParkTower.self, hashKey: "demo-key-3", rangeKey: "demo-timestamp-500000") { (response: AWSDynamoDBObjectModel?, error: Error?) in
            DispatchQueue.main.async(execute: {
                completionHandler(response, error as NSError?)
            })
        }
    }
    
    func scanDescription() -> String {
        return "Show all items in the table."
    }
    
    func scanWithCompletionHandler(_ completionHandler: @escaping (_ response: AWSDynamoDBPaginatedOutput?, _ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.limit = 5

        objectMapper.scan(SanoParkTower.self, expression: scanExpression) { (response: AWSDynamoDBPaginatedOutput?, error: Error?) in
            DispatchQueue.main.async(execute: {
                completionHandler(response, error as NSError?)
            })
        }
    }
    
    func scanWithFilterDescription() -> String {
        let scanFilterValue = "demo-value-500000"
        return "Find all items with value < \(scanFilterValue)."
    }
    
    func scanWithFilterWithCompletionHandler(_ completionHandler: @escaping (_ response: AWSDynamoDBPaginatedOutput?, _ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let scanExpression = AWSDynamoDBScanExpression()
        
        scanExpression.filterExpression = "#value < :value"
        scanExpression.expressionAttributeNames = ["#value": "value" ,]
        scanExpression.expressionAttributeValues = [":value": "demo-value-500000" ,]

        objectMapper.scan(SanoParkTower.self, expression: scanExpression) { (response: AWSDynamoDBPaginatedOutput?, error: Error?) in
            DispatchQueue.main.async(execute: {
                completionHandler(response, error as? NSError)
            })
        }
    }
    
    func insertSampleDataWithCompletionHandler(_ completionHandler: @escaping (_ errors: [NSError]?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        var errors: [NSError] = []
        let group: DispatchGroup = DispatchGroup()
        let numberOfObjects = 20
        

        let itemForGet: SanoParkTower! = SanoParkTower()
        
        itemForGet._key = "demo-key-3"
        itemForGet._timestamp = "demo-timestamp-500000"
        itemForGet._value = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("value")
        
        
        group.enter()
        

        objectMapper.save(itemForGet, completionHandler: {(error: Error?) -> Void in
            if let error = error as? NSError {
                DispatchQueue.main.async(execute: {
                    errors.append(error)
                })
            }
            group.leave()
        })
        
        for _ in 1..<numberOfObjects {

            let item: SanoParkTower = SanoParkTower()
            item._key = NoSQLSampleDataGenerator.randomPartitionSampleStringWithAttributeName("key")
            item._timestamp = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("timestamp")
            item._value = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("value")
            
            group.enter()
            
            objectMapper.save(item, completionHandler: {(error: Error?) -> Void in
                if error != nil {
                    DispatchQueue.main.async(execute: {
                        errors.append(error! as NSError)
                    })
                }
                group.leave()
            })
        }
        
        group.notify(queue: DispatchQueue.main, execute: {
            if errors.count > 0 {
                completionHandler(errors)
            }
            else {
                completionHandler(nil)
            }
        })
    }
    
    func removeSampleDataWithCompletionHandler(_ completionHandler: @escaping ([NSError]?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.filterExpression = "begins_with(#key, :key)"
        scanExpression.expressionAttributeNames = ["#key": "key"]
        scanExpression.expressionAttributeValues = [":key": "demo-"]

        objectMapper.scan(SanoParkTower.self, expression: scanExpression) { (response: AWSDynamoDBPaginatedOutput?, error: Error?) in
            if let error = error as? NSError {
                DispatchQueue.main.async(execute: {
                    completionHandler([error]);
                    })
            } else {
                var errors: [NSError] = []
                let group: DispatchGroup = DispatchGroup()
                for item in response!.items {
                    group.enter()
                    objectMapper.remove(item, completionHandler: {(error: Error?) in
                        if let error = error as? NSError {
                            DispatchQueue.main.async(execute: {
                                errors.append(error)
                            })
                        }
                        group.leave()
                    })
                }
                group.notify(queue: DispatchQueue.main, execute: {
                    if errors.count > 0 {
                        completionHandler(errors)
                    }
                    else {
                        completionHandler(nil)
                    }
                })
            }
        }
    }
    
    func updateItem(_ item: AWSDynamoDBObjectModel, completionHandler: @escaping (_ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        

        let itemToUpdate: SanoParkTower = item as! SanoParkTower
        
        itemToUpdate._value = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("value")
        
        objectMapper.save(itemToUpdate, completionHandler: {(error: Error?) in
            DispatchQueue.main.async(execute: {
                completionHandler(error as? NSError)
            })
        })
    }
    
    func removeItem(_ item: AWSDynamoDBObjectModel, completionHandler: @escaping (_ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        
        objectMapper.remove(item, completionHandler: {(error: Error?) in
            DispatchQueue.main.async(execute: {
                completionHandler(error as? NSError)
            })
        })
    }
}

class SanoParkTowerPrimaryIndex: NSObject, Index {
    
    var indexName: String? {
        return nil
    }
    
    func supportedOperations() -> [String] {
        return [
            QueryWithPartitionKey,
            QueryWithPartitionKeyAndFilter,
            QueryWithPartitionKeyAndSortKey,
            QueryWithPartitionKeyAndSortKeyAndFilter,
        ]
    }
    
    func queryWithPartitionKeyDescription() -> String {
        let partitionKeyValue = "demo-key-3"
        return "Find all items with key = \(partitionKeyValue)."
    }
    
    func queryWithPartitionKeyWithCompletionHandler(_ completionHandler: @escaping (_ response: AWSDynamoDBPaginatedOutput?, _ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "#key = :key"
        queryExpression.expressionAttributeNames = ["#key": "key",]
        queryExpression.expressionAttributeValues = [":key": "demo-key-3",]

        objectMapper.query(SanoParkTower.self, expression: queryExpression) { (response: AWSDynamoDBPaginatedOutput?, error: Error?) in
            DispatchQueue.main.async(execute: {
                completionHandler(response, error as? NSError)
            })
        }
    }
    
    func queryWithPartitionKeyAndFilterDescription() -> String {
        let partitionKeyValue = "demo-key-3"
        let filterAttributeValue = "demo-value-500000"
        return "Find all items with key = \(partitionKeyValue) and value > \(filterAttributeValue)."
    }
    
    func queryWithPartitionKeyAndFilterWithCompletionHandler(_ completionHandler: @escaping (_ response: AWSDynamoDBPaginatedOutput?, _ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "#key = :key"
        queryExpression.filterExpression = "#value > :value"
        queryExpression.expressionAttributeNames = [
            "#key": "key",
            "#value": "value",
        ]
        queryExpression.expressionAttributeValues = [
            ":key": "demo-key-3",
            ":value": "demo-value-500000",
        ]
        

        objectMapper.query(SanoParkTower.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: Error?) in
            DispatchQueue.main.async(execute: {
                completionHandler(response, error as? NSError)
            })
        })
    }
    
    func queryWithPartitionKeyAndSortKeyDescription() -> String {
        let partitionKeyValue = "demo-key-3"
        let sortKeyValue = "demo-timestamp-500000"
        return "Find all items with key = \(partitionKeyValue) and timestamp < \(sortKeyValue)."
    }
    
    func queryWithPartitionKeyAndSortKeyWithCompletionHandler(_ completionHandler: @escaping (_ response: AWSDynamoDBPaginatedOutput?, _ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "#key = :key AND #timestamp < :timestamp"
        queryExpression.expressionAttributeNames = [
            "#key": "key",
            "#timestamp": "timestamp",
        ]
        queryExpression.expressionAttributeValues = [
            ":key": "demo-key-3",
            ":timestamp": "demo-timestamp-500000",
        ]
        

        objectMapper.query(SanoParkTower.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: Error?) -> Void in
            DispatchQueue.main.async(execute: {
                completionHandler(response, error as? NSError)
            })
        })
    }
    
    func queryWithPartitionKeyAndSortKeyAndFilterDescription() -> String {
        let partitionKeyValue = "demo-key-3"
        let sortKeyValue = "demo-timestamp-500000"
        let filterValue = "demo-value-500000"
        return "Find all items with key = \(partitionKeyValue), timestamp < \(sortKeyValue), and value > \(filterValue)."
    }
    
    func queryWithPartitionKeyAndSortKeyAndFilterWithCompletionHandler(_ completionHandler: @escaping (_ response: AWSDynamoDBPaginatedOutput?, _ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "#key = :key AND #timestamp < :timestamp"
        queryExpression.filterExpression = "#value > :value"
        queryExpression.expressionAttributeNames = [
            "#key": "key",
            "#timestamp": "timestamp",
            "#value": "value",
        ]
        queryExpression.expressionAttributeValues = [
            ":key": "demo-key-3",
            ":timestamp": "demo-timestamp-500000",
            ":value": "demo-value-500000",
        ]
        

        objectMapper.query(SanoParkTower.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: Error?) in
            DispatchQueue.main.async(execute: {
                completionHandler(response, error as? NSError)
            })
        })
    }
    
    
}
