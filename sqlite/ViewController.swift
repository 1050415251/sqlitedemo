//
//  ViewController.swift
//  sqlite
//
//  Created by 国投 on 2018/5/10.
//  Copyright © 2018年 FlyKite. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        //TODO: 打开 sq
        var db:OpaquePointer? = nil
        var path = NSHomeDirectory()
        path = NSString.path(withComponents: [path,"mydb.sqlite"])
        debugPrint(path)
        //提供c的字符串 和 ppdb
        if sqlite3_open(path.cString(using: String.Encoding.utf8), &db) == SQLITE_OK {
            debugPrint("数据库打开成功")
        }else {
            debugPrint("数据库打开失败")
        }
        let sql = "create table if not exists t_student(name text,age integer)"
        let errmsg:UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>? = nil
        //TODO: 进行操作
        if sqlite3_exec(db, sql.cString(using: String.Encoding.utf8), nil, nil, errmsg) == SQLITE_OK {
            debugPrint("操作成功")
        }
        else {
            debugPrint("操作失败")
        }

//        //TODO: 增
//        let addsql = "insert into t_student(name,age) values('李二牛',18)"
//        //TODO: 进行操作
//        if sqlite3_exec(db, addsql.cString(using: String.Encoding.utf8), nil, nil, errmsg) == SQLITE_OK {
//            debugPrint("操作成功")
//        }
//        else {
//
//            debugPrint("操作失败")
//        }


        let addSql = "insert into t_student(name,age) values(?,?)"
        var addstmt : OpaquePointer? = nil
        let name = "离开"
        let age:Int = 30
        if sqlite3_prepare_v2(db, addSql.cString(using: String.Encoding.utf8), -1, &addstmt, nil) == SQLITE_OK {
            let result = sqlite3_bind_text(addstmt, 1,(name as NSString).utf8String, -1, nil)
            let result2 = sqlite3_bind_int(addstmt, 2, Int32(age))
            if result == SQLITE_OK && result2 == SQLITE_OK {
                debugPrint("成功")
            }

        }
        if sqlite3_step(addstmt) == SQLITE_DONE{
            debugPrint("操作成功")
        }
        else {
            debugPrint("操作失败")
        }
        sqlite3_finalize(addstmt)




        let changesql = "update t_student set name = '洋' where age=80"
        //TODO: 进行操作
        if sqlite3_exec(db, changesql.cString(using: String.Encoding.utf8), nil, nil, errmsg) == SQLITE_OK {
            debugPrint("操作成功")
        }
        else {
            debugPrint("操作失败")
        }

//        let deletesql = "delete from t_student where age=0"
//        //TODO: 进行操作
//        if sqlite3_exec(db, deletesql.cString(using: String.Encoding.utf8), nil, nil, errmsg) == SQLITE_OK {
//            debugPrint("操作成功")
//        }
//        else {
//            debugPrint("操作失败")
//        }


        //定义游标对象
        var stmt : OpaquePointer? = nil
        let findsql = "select * from t_student"
        //TODO: 进行操作
        if sqlite3_prepare_v2(db, findsql.cString(using: String.Encoding.utf8), -1, &stmt, nil) == SQLITE_OK {


            while sqlite3_step(stmt) == SQLITE_ROW {
                var result = [String:Any]()
                let data = sqlite3_column_count(stmt)
                for i in 0..<data {
                    let ckey = sqlite3_column_name(stmt, i)
                    let key = String.init(validatingUTF8: ckey!)!
                    if key == "name" {
                        if let cValue = sqlite3_column_text(stmt, i) {
                            let value = String.init(cString: cValue)
                            result[key] = value
                        }else {
                            result[key] = ""
                        }
                    }
                    else if key == "age" {
                        let cValue = sqlite3_column_int64(stmt, i)
                        let value = cValue
                        result[key] = value
                    }

                }
                debugPrint(result)
            }


        }else {
            debugPrint("查询失败")
            
        }
        //TODO: 释放
        sqlite3_finalize(stmt)
        //TODO: 关闭 sq
        sqlite3_close(db)

    }
}
































