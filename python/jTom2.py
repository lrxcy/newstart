# -*- coding:utf-8 -*-

import json
from pymongo import *


class JsonToMongo(object):
    def __init__(self):
        self.host = 'localhost'
        self.port = 27017

    # 读取json文件
    def __open_file(self):
        self.file = open('ssl.json', 'r')

        # python序列化
        # self.data = json.load(self.file)

        # 创建mongodb客户端
        self.client = MongoClient(self.host, self.port)
        # 创建数据库
        self.db = self.client.domain_ssl
        # 创建集合
        self.collection = self.db.ssl

    # 关闭文件
    def __close_file(self):
        self.file.close()

    # 插入数据
    def insert_data(self, result):
        try:
            self.collection.insert_one(result)
            # print 'insert successfully!'
        except Exception as e:
            print e
        finally:
            self.__close_file()

    # 更新数据（待修复）
    # def update_data(self, result):
    #     try:
    #         courseId = self.db.save(self.datadict)
    #         courseId = str(courseId)
    #         print "courseId: " + courseId
    #         print "lec length: " + str(len(lecDataArr))
    #
    #         # insert lecture
    #         lecIdArr = []
    #         for lecData in lecDataArr:
    #             lecData["course_id"] = courseId
    #             lecId = lecTable.save(lecData)
    #             lecIdArr.append(str(lecId))
    #
    #         # update course
    #         self.collection.update({'_id': bson.objectid.ObjectId(courseId)},
    #                            {"$set": {"lectures.lecture_id_list": lecIdArr}},
    #                            upsert=True, multi=True)
    #         # self.collection.update(self.collection, result)
    #         print 'update successfully!'
    #     except Exception as e:
    #         print e
    #     finally:
    #         self.__close_file()

    # 写入数据库
    def write_database(self):
        self.__open_file()

        # 转换为python对象
        self.datas = json.load(self.file)

        for self.n_data in self.datas:
            self.find_result = self.collection.find_one(self.n_data)

            if self.find_result == None:
                self.insert_data(self.n_data)
            else:
                continue

        # 统计记录
        count = self.collection.find().count()
        print("A total of {} records".format(count))


if __name__ == '__main__':
    j2m = JsonToMongo()
    j2m.write_database()
