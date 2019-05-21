# 上传图片到github
import sys
import os
import time

class Upload_handler(object):
    def __init__(self, path):
        self.project_path = path
        self.project_name = "article-images"
        self.project_repositoritory = f"git@github.com:fadeawaylove/{self.project_name}.git"  # 图床项目的地址
        self.img_base_url = "https://raw.githubusercontent.com/fadeawaylove/article-images/master/"  # 这是图片的基本地址+{img_name}
    
    def _upload(self, image_name):
        # 1.先读取文件
        with open(image_name, "rb") as f:
            image_name, suffix = image_name.split('.')[-1]
            new_image_name = image_name + "-" + str(int(time.time()))
            # 2.将仓库clone或者下载下来
            os.chdir(self.project_path)
            if os.path.exists(self.project_name):
                # 切换进去，然后pull
                os.chdir(self.project_name)
                os.system("git pull")
            else:
                os.system("git clone {}".format(self.project_repositoritory))
                os.chdir(self.project_name)
            # 3.复制文件
            with open(new_image_name + '.' + suffix, "wb") as f2:
                for line in f:
                    f2.write(line)
            # 4.推送到远程
            os.system("git add .")
            os.system("git commit -m add_img_{}".format(new_image_name))
            os.system("git push origin master")
        return new_image_name

    def _get_img_url(self, img_name):
        return {self.img_base_url} + {img_name}

    def run(self, image_name):
        file_name = self._upload(image_name)
        return self._get_img_url(file_name)

# 注意，运行的时候是在图片所在的目录下
if __name__ == "__main__":
    # 将项目路径设置为此文件的同级目录
    project_path = os.path.dirname(os.path.abspath(__file__))
    print("project_path: {}".format(project_path))
    # 获取命令行传来的图片文件名
    image_name = sys.argv[-1]
    print(12313)
    print(image_name)
    if not image_name:
        raise Exception("there must be a image name in command line!")
    # 创建handler对象
    u = Upload_handler(project_path)
    img_url = u.run(image_name)
    print("恭喜你，上传图片成功，图片链接如下:")
    print(img_url)