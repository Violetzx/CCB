import os
import re
import glob

def xml_to_sql(xml_content):
    """转换XML内容为SQL格式"""
    entries = []
    current_tag = ""
    current_lang = ""
    current_text = []
    comments = []
    in_replace = False
    in_text = False

    lines = xml_content.split('\n')
    for line in lines:
        stripped = line.strip()

        # 处理注释行
        if stripped.startswith('<!--') and stripped.endswith('-->'):
            comment = stripped[4:-3].strip()
            comments.append(f"-- {comment}")
            continue

        # 处理Replace标签开始
        if ('<Replace ' in stripped or '<Row ' in stripped) and '>' in stripped:
            in_replace = True
            tag_match = re.search(r'Tag="([^"]+)"', stripped)
            lang_match = re.search(r'Language="([^"]+)"', stripped)

            if tag_match and lang_match:
                current_tag = tag_match.group(1)
                current_lang = lang_match.group(1)
            continue

        # 处理Text标签开始
        if in_replace and '<Text>' in stripped:
            in_text = True
            text_content = stripped.replace('<Text>', '', 1)
            if '</Text>' in text_content:
                # 单行文本
                text_content = text_content.replace('</Text>', '')
                current_text.append(text_content.strip())
                in_text = False
                in_replace = False
            else:
                current_text.append(text_content.strip())
            continue

        # 处理Text标签内的内容
        if in_text and in_replace:
            if '</Text>' in stripped:
                # 文本结束
                text_content = stripped.replace('</Text>', '')
                current_text.append(text_content.strip())
                in_text = False
                in_replace = False
            else:
                current_text.append(stripped)
            continue

        # 完成一个Replace标签
        if not in_replace and current_tag and current_lang and current_text:
            # 合并文本内容
            full_text = ' '.join(' '.join(current_text).split())
            full_text = full_text.replace('"', '""')

            # 添加注释和条目
            if comments:
                entries.extend(comments)
                comments = []

            entries.append(f'("{current_tag}","{current_lang}","{full_text}"),')

            # 重置变量
            current_tag = ""
            current_lang = ""
            current_text = []

    # 处理最后一个条目
    if current_tag and current_lang and current_text:
        full_text = ' '.join(' '.join(current_text).split())
        full_text = full_text.replace('"', '""')

        if comments:
            entries.extend(comments)

        entries.append(f'("{current_tag}","{current_lang}","{full_text}"),')

    # 构建SQL内容
    if not entries:
        return ""

    # 确保最后一行以分号结尾
    if entries[-1].endswith(','):
        entries[-1] = entries[-1][:-1] + ';'

    return "INSERT OR REPLACE INTO LocalizedText(Tag,Language,Text)VALUES\n" + "\n".join(entries)


def convert_xml_files():
    """转换当前目录下所有XML文件"""
    for xml_file in glob.glob("*.xml"):
        try:
            with open(xml_file, 'r', encoding='utf-8') as f:
                xml_content = f.read()

            sql_content = xml_to_sql(xml_content)
            if not sql_content:
                print(f"跳过空文件: {xml_file}")
                continue

            sql_file = os.path.splitext(xml_file)[0] + ".sql"
            with open(sql_file, 'w', encoding='utf-8') as f:
                f.write(sql_content)

            print(f"转换完成: {xml_file} -> {sql_file}")

        except Exception as e:
            print(f"处理文件 {xml_file} 时出错: {str(e)}")


def main():
    convert_xml_files()

    print("Success.")


if __name__ == "__main__":
    main()