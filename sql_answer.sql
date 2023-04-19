--問題37！ 49！ 50! 51! 52! 58! 64!
--わからない問題:23 22 新33
--日時と関係あるSQL文すべて実行出来ない18,19、20,21とか


--問題1：各グループの中でFIFAランクが最も高い国と低い国のランキング番号を表示してください。
SELECT
    group_name AS グループ
    , MIN(ranking) AS ランキング最上位
    , MAX(ranking) AS ランキング最下位 
FROM
    countries 
GROUP BY
    group_name
    
    

--問題2：全ゴールキーパーの平均身長、平均体重を表示してください
select avg(height) as 平均身長, avg(weight) as 平均体重 from players



--問題3：各国の平均身長を高い方から順に表示してください。ただし、FROM句はcountriesテーブルとしてください。
select
    countries.name
    , avg(players.height) 
from
    countries join players 
        on countries.id = players.country_id 
group by
    countries.id
    , countries.name 
order by
    avg(players.height) desc



--問題4：各国の平均身長を高い方から順に表示してください。ただし、FROM句はplayersテーブルとして、テーブル結合を使わず副問合せを用いてください。
select
    ( 
        select
            c.name 
        from
            countries c 
        where
            c.id = p.country_id
    ) as 国
    , avg(p.height) as 平均身長 
from
    players p 
group by
    p.country_id 
order by
    avg(p.height) desc;




--問題5：キックオフ日時と対戦国の国名をキックオフ日時の早いものから順に表示してください
SELECT
    kickoff AS キックオフ日時
    , c1.name AS 国名1
    , c2.name AS 国名2 
FROM
    pairings p 
    LEFT JOIN countries c1 
        ON p.my_country_id = c1.id 
    LEFT JOIN countries c2 
        ON p.enemy_country_id = c2.id 
ORDER BY
    kickoff
    
    

--問題6：すべての選手を対象として選手ごとの得点ランキングを表示してください。（SELECT句で副問合せを使うこと）
SELECT p.name AS 名前, p.position AS ポジション, p.club AS 所属クラブ, 
    (SELECT COUNT(id) FROM goals g WHERE g.player_id = p.id) AS ゴール数
FROM players p
ORDER BY ゴール数 DESC



--問題7：すべての選手を対象として選手ごとの得点ランキングを表示してください。（テーブル結合を使うこと）
SELECT
    p.name AS 名前
    , p.position AS ポジション
    , p.club AS 所属クラブ
    , COUNT(g.id) AS ゴール数 
FROM
    players p 
    LEFT JOIN goals g 
        ON g.player_id = p.id 
GROUP BY
    p.id
    , p.name
    , p.position
    , p.club 
ORDER BY
    ゴール数 DESC



--問題8：各ポジションごとの総得点を表示してください。
select
    p.position
    , count(g.id) 
from
    players p 
    left join goals g 
        on p.id = g.player_id 
group by
    p.position



--問題9：ワールドカップ開催当時（2014-06-13）の年齢をプレイヤー毎に表示する。
SELECT
    birth
    , TIMESTAMPDIFF(YEAR, birth, '2014-06-13') AS age
    , name
    , position 
FROM
    players 
ORDER BY
    age DESC;


--問題10：オウンゴールの回数を表示する
SELECT
    COUNT(g.goal_time) 
FROM
    goals g 
WHERE
    g.player_id IS NULL;



--問題11：各グループごとの総得点数を表示して下さい。
SELECT
    c.group_name
    , count(g.id) 
FROM
    goals g 
    LEFT JOIN pairings p 
        ON p.id = g.pairing_id 
    LEFT JOIN countries c 
        ON p.my_country_id = c.id 
WHERE
    p.kickoff BETWEEN '2014-06-13 0:00:00' AND '2014-06-27 23:59:59' 
GROUP BY
    c.group_name



--問題12：日本VSコロンビア戦（pairings.id = 103）でのコロンビアの得点のゴール時間を表示してください
SELECT
    goal_time 
FROM
    goals 
WHERE
    pairing_id = 103



--問題13：日本VSコロンビア戦の勝敗を表示して下さい。
SELECT
    c.name
    , COUNT(g.goal_time) 
FROM
    goals g 
    LEFT JOIN pairings p 
        ON p.id = g.pairing_id 
    LEFT JOIN countries c 
        ON p.my_country_id = c.id 
WHERE
    p.id = 103 
    OR p.id = 39 
GROUP BY
    c.name


select * from countries as 国;
select * from pairings as 国情報;
select * from goals as 点数情報;



--問題14：グループCの各対戦毎にゴール数を表示してください
SELECT p1.kickoff, c1.name AS my_country, c2.name AS enemy_country,
    c1.ranking AS my_ranking, c2.ranking AS enemy_ranking,
    COUNT(g1.id) AS my_goals
FROM pairings p1
LEFT JOIN countries c1 ON c1.id = p1.my_country_id
LEFT JOIN countries c2 ON c2.id = p1.enemy_country_id
LEFT JOIN goals g1 ON p1.id = g1.pairing_id
WHERE c1.group_name = 'C' AND c2.group_name = 'C'
GROUP BY p1.kickoff, c1.name, c2.name, c1.ranking, c2.ranking
ORDER BY p1.kickoff, c1.ranking



--問題15：グループCの各対戦毎にゴール数を表示してください。
--問題１４と同じ



--問題16：グループCの各対戦毎にゴール数を表示してください。
SELECT p1.kickoff, c1.name AS my_country, c2.name AS enemy_country, 
    c1.ranking AS my_ranking, c2.ranking AS enemy_ranking,
   
    (SELECT COUNT(g1.id) FROM goals g1 WHERE p1.id = g1.pairing_id) AS my_goals,
    (
        SELECT COUNT(g2.id) 
        FROM goals g2 
        LEFT JOIN pairings p2 ON p2.id = g2.pairing_id
        WHERE p2.my_country_id = p1.enemy_country_id AND p2.enemy_country_id = p1.my_country_id
    ) AS enemy_goals
FROM pairings p1
LEFT JOIN countries c1 ON c1.id = p1.my_country_id
LEFT JOIN countries c2 ON c2.id = p1.enemy_country_id
WHERE c1.group_name = 'C' AND c2.group_name = 'C'
ORDER BY p1.kickoff, c1.ranking



--問題17：問題16の結果に得失点差を追加してください。
SELECT p1.kickoff, c1.name AS my_country, c2.name AS enemy_country, 
    c1.ranking AS my_ranking, c2.ranking AS enemy_ranking,
    (SELECT COUNT(g1.id) FROM goals g1 WHERE p1.id = g1.pairing_id) AS my_goals,
    (
        SELECT COUNT(g2.id) 
        FROM goals g2 
        LEFT JOIN pairings p2 ON p2.id = g2.pairing_id
        WHERE p2.my_country_id = p1.enemy_country_id AND p2.enemy_country_id = p1.my_country_id
    ) AS enemy_goals,
    -- 追加ここから
    (SELECT COUNT(g1.id) FROM goals g1 WHERE p1.id = g1.pairing_id) - ( 
        SELECT COUNT(g2.id) 
        FROM goals g2 
        LEFT JOIN pairings p2 ON p2.id = g2.pairing_id
        WHERE p2.my_country_id = p1.enemy_country_id AND p2.enemy_country_id = p1.my_country_id
    ) AS goal_diff
    -- 追加ここまで
FROM pairings p1
LEFT JOIN countries c1 ON c1.id = p1.my_country_id
LEFT JOIN countries c2 ON c2.id = p1.enemy_country_id
WHERE c1.group_name = 'C' AND c2.group_name = 'C'
ORDER BY p1.kickoff, c1.ranking



--問題18：ブラジル（my_country_id = 1）対クロアチア（enemy_country_id = 4）戦のキックオフ時間（現地時間）を表示してください。
SELECT
    p.kickoff
    , p.kickoff - cast('12 hours' as INTERVAL) AS kickoff_jp 
FROM
    pairings p 
WHERE
    p.my_country_id = 1 
    AND p.enemy_country_id = 4;


--問題19：年齢ごとの選手数を表示してください。（年齢はワールドカップ開催当時である2014-06-13を使って算出してください。）
select
    date_part('year', AGE('2014-06-13', birth)) as age
    , COUNT(id) AS player_count 
FROM
    players 
GROUP BY
    age 
order by
    age



--問題20：年齢ごとの選手数を表示してください。ただし、10歳毎に合算して表示してください。
select
    count(date_part('year', AGE('2014-06-13', birth)) between 10 and 20) as age,
    COUNT(id) AS player_count 
FROM
    players 
    where 
    date_part('year', AGE('2014-06-13', birth)) between 10 and 20 
order by
    age
    
    

    select
        date_part('year', AGE('2014-06-13', birth)) as age
        , COUNT(id)AS player_count 
    FROM
        players where 
        date_part('year', AGE('2014-06-13', birth)) between 10 and 19 
    GROUP BY
        age 
    order by
        age



---問題21：年齢ごとの選手数を表示してください。ただし、5歳毎に合算して表示してください。



--問題22：以下の条件でSQLを作成し、抽出された結果をもとにどのような傾向があるか考えてみてください。
SELECT FLOOR(TIMESTAMPDIFF(YEAR, birth, '2014-06-13') / 5) * 5   AS age, position, COUNT(id) AS player_count, AVG(height), AVG(weight)
FROM players 
GROUP BY age, position
ORDER BY age, position



--問題23：身長の高い選手ベスト5を抽出し、以下の項目を表示してください。
SELECT name, height, weight
FROM players
ORDER BY height DESC
LIMIT 5



--問題24：身長の高い選手6位～20位を抽出し、以下の項目を表示してください。
SELECT name, height, weight
FROM players
ORDER BY height DESC
LIMIT (5) offset (15)




--問題25：全選手の以下のデータを抽出してください。
         --・背番号（uniform_num）
         --・名前（name）
         --・所属クラブ（club）
select uniform_num,name,club from players;



--問題26：グループCに所属する国をすべて抽出してください。
select * from countries where group_name = 'C';



--問題27：グループC以外に所属する国をすべて抽出してください
select * from countries where group_name <> 'C';



--問題28：2016年1月13日現在で40歳以上の選手を抽出してください。（誕生日の人を含めてください。）
select * from players where birth <= '1976-1-13';



--問題29：身長が170cm未満の選手を抽出してください。
select * from players where height < 170;



--問題30：FIFAランクが日本（46位）の前後10位に該当する国（36位～56位）を抽出してください。ただし、BETWEEN句を用いてください。
select * from countries where ranking between 36 and 56;



--問題31：選手のポジションがGK、DF、MFに該当する選手をすべて抽出してください。ただし、IN句を用いてください。
select * from players where position in ('GK','DF','MF');



--問題32：オウンゴールとなったゴールを抽出してください。goalsテーブルのplayer_idカラムにNULLが格納されているデータがオウンゴールを表しています。
select * from goals where player_id is NULL;



--問題33：オウンゴール以外のゴールを抽出してください。goalsテーブルのplayer_idカラムにNULLが格納されているデータがオウンゴールを表しています。
select * from goals where player_id is not null;



--問題34：名前の末尾が「ニョ」で終わるプレイヤーを抽出してください。
select * from players where name like  '%ニョ';



--問題35：名前の中に「ニョ」が含まれるプレイヤーを抽出してください。
select * from players where name like '%ニョ%';



--問題36：グループA以外に所属する国をすべて抽出してください。ただし、「!=」や「<>」を使わずに、「NOT」を使用してください。
select * from countries where not group_name = 'A';



--問題37：全選手の中でBMI値が20台の選手を抽出してください。BMIは以下の式で求めることができます。
--sqlの中で、２の二乗の書き方はpow(2,2) 
select * from players where weight / POW (height / 100,2) > =20 and weight / POW (height / 100,2) < 21



--問題38：全選手の中から小柄な選手（身長が165cm未満か、体重が60kg未満）を抽出してください。
select * from players where height < 165 or height < 60



--問題39：FWかMFの中で170未満の選手を抽出してください。ただし、ORとANDを使用してください。
select * from players where ( position = 'MF' or position = 'FW') and height < 170



--問題40：ポジションの一覧を重複なしで表示してください。グループ化は使用しないでください。
select distinct position from players



--問題41：全選手の身長と体重を足した値を表示してください。合わせて選手の名前、選手の所属クラブも表示してください。
select name ,club ,height + weight from players



--問題42：選手名とポジションを以下の形式で出力してください。シングルクォートに注意してください。
select
    concat(name, '選手のポジションは', position, 'です') 
from
    players;



--問題43：全選手の身長と体重を足した値をカラム名「体力指数」として表示してください。合わせて選手の名前、選手の所属クラブも表示してください。
select 
   name,club,height + weight as 体力指数
from 
    players;
    
    

--問題44：FIFAランクの高い国から順にすべての国名を表示してください。
select 
    ranking
from
    countries order by ranking;
    
    
    
--問題45：全ての選手を年齢の低い順に表示してください。なお、年齢を計算する必要はありません。
select
    * 
from
    players 
order by
    birth desc;
    
    
    
--問題46：全ての選手を身長の大きい順に表示してください。同じ身長の選手は体重の重い順に表示してください。
select
    * 
from
    players 
order by
    height desc
    , weight desc;



--問題47：全ての選手のポジションの1文字目（GKであればG、FWであればF）を出力してください。
select
    id
    , country_id
    , uniform_num
    , substring(position, 1, 1)
    , name 
from
    players;



--問題48：出場国の国名が長いものから順に出力してください。
select
    name 
from
    countries 
order by
    length(name) desc;



---問題49：全選手の誕生日を「2017年04月30日」のフォーマットで出力してください。
select
    name
    ,date_format(birth,'%y年%m月%d日') as birthday
from 
    players;
    
    
    
--問題50：全てのゴール情報を出力してください。ただし、オウンゴール（player_idがNULLのデータ）はIFNULL関数を使用してplayer_idを「9999」と表示してください。
select 
    IFNULL(player_id,9999) as player_id, goal_time
from 
    goals
    


--問題51：全てのゴール情報を出力してください。ただし、オウンゴール（player_idがNULLのデータ）はCASE関数を使用してplayer_idを「9999」と表示してください。
SELECT
    CASE 
        WHEN player_id IS NULL 
            THEN 9999 
        ELSE player_id 
        END AS player_id
    , goal_time 
FROM
    goals



--問題52：全ての選手の平均身長、平均体重を表示してください。
select
    avg(height) as 平均身長
    , avg(weight) as 平均体重
from
    players;



--問題53：日本の選手（player_idが714から736）が上げたゴール数を表示してください。
select
    count(id) as 日本のゴール数 
from
    goals 
where
    player_id between 714 and 736;



--問題54：オウンゴール（player_idがNULL）以外の総ゴール数を表示してください。ただし、WHERE句は使用しないでください。
SELECT
    COUNT(player_id) AS オウンゴール以外のゴール数 
FROM
    goals;



--問題55：全ての選手の中で最も高い身長と、最も重い体重を表示してください。
select
    max(height) as 最も高い身長
    , max(weight) as 最も重い体重 
from
    players;



--問題56：AグループのFIFAランク最上位を表示してください。
SELECT
    MIN(ranking) AS AグループのFIFAランク最上位 
FROM
    countries 
WHERE
    group_name = 'A';



--問題57：CグループのFIFAランクの合計値を表示してください。
select
    sum(ranking) as CグループのFIFAランクの合計値 
from
    countries 
where
    group_name = 'C';



--問題58：全ての選手の所属国と名前、背番号を表示してください。
SELECT c.name, p.name, p.uniform_num
FROM players p
JOIN countries c ON c.id = p.country_id



--問題59：全ての試合の国名と選手名、得点時間を表示してください。オウンゴール（player_idがNULL）は表示しないでください。

SELECT c.name, p.name, g.goal_time
FROM goals g
JOIN players p ON g.player_id = p.id
JOIN countries c ON p.country_id = c.id



--問題60：全ての試合のゴール時間と選手名を表示してください。左側外部結合を使用してオウンゴール（player_idがNULL）も表示してください
SELECT g.goal_time, p.name
FROM goals g
LEFT JOIN players p ON g.player_id = p.id



--問題61：全ての試合のゴール時間と選手名を表示してください。右側外部結合を使用してオウンゴール（player_idがNULL）も表示してください。
select g.goal_time, p.name
from players p
right join goals g ON g.player_id = p.id



--問題62：全ての試合のゴール時間と選手名、国名を表示してください。また、オウンゴール（player_idがNULL）も表示してください。
SELECT c.name , g.goal_time,  p.name
FROM goals g
LEFT JOIN players p ON g.player_id = p.id
LEFT JOIN countries c ON p.country_id = c.id

SELECT c.name AS country_name, g.goal_time, p.position, p.name AS player_name
FROM goals g
LEFT JOIN players p ON g.player_id = p.id
LEFT JOIN countries c ON p.country_id = c.id



--問題63：全ての試合のキックオフ時間と対戦国の国名を表示してください。
SELECT
    p.kickoff
    , mc.name AS my_country
    , ec.name AS enemy_country 
FROM
    pairings p JOIN countries mc 
        ON mc.id = my_country_id JOIN countries ec 
        on ec.id = enemy_country_id




--問題64：全てのゴール時間と得点を上げたプレイヤー名を表示してください。オウンゴールは表示しないでください。ただし、結合は使わずに副問合せを用いてください。
SELECT
    g.id
    , g.goal_time
    , ( 
        SELECT
            p.name 
        FROM
            players p 
        WHERE
            p.id = g.player_id
    ) AS player_name 
FROM
    goals g 
WHERE
    g.player_id IS NOT NULL



--問題65：全てのゴール時間と得点を上げたプレイヤー名を表示してください。オウンゴールは表示しないでください。ただし、副問合せは使わずに、結合を用いてください。
SELECT
    
    g.goal_time
    , p.name 
FROM
    goals g JOIN players p 
        ON p.id = g.player_id



--問題66：各ポジションごと（GK、FWなど）に最も身長と、その選手名、所属クラブを表示してください。ただし、FROM句に副問合せを使用してください
SELECT
    p1.position
    , p1.最大身長
    , p2.name
    , p2.club 
FROM
    ( 
        SELECT
            position
            , MAX(height) AS 最大身長 
        FROM
            players 
        GROUP BY
            position
    ) p1 
    LEFT JOIN players p2 
        ON p1.最大身長 = p2.height 
        AND p1.position = p2.position



--問題67：各ポジションごと（GK、FWなど）に最も身長と、その選手名を表示してください。ただし、SELECT句に副問合せを使用してください。
SELECT
    p1.position
    , MAX(p1.height) AS 最大身長
    , ( 
        SELECT
            p2.name 
        FROM
            players p2 
        WHERE
            MAX(p1.height) = p2.height 
            AND p1.position = p2.position
    ) AS 名前 
FROM
    players p1 
GROUP BY
    p1.position



--問題68：全選手の平均身長より低い選手をすべて抽出してください。表示する列は、背番号、ポジション、名前、身長としてください。
select
    uniform_num
    , position
    , name
    , height 
from
    players 
where
    height < (select avg(height) from players)



--問題69：各グループの最上位と最下位を表示し、その差が50より大きいグループを抽出してください。
SELECT
    group_name
    , MAX(ranking)
    , MIN(ranking) 
FROM
    countries 
GROUP BY
    group_name 
HAVING
    MAX(ranking) - MIN(ranking) > 50



--問題70：1980年生まれと、1981年生まれの選手が何人いるか調べてください。ただし、日付関数は使用せず、UNION句を使用してください。
SELECT
    '1980' AS 誕生年
    , COUNT(id) 
FROM
    players 
WHERE
    birth BETWEEN '1980-1-1' AND '1980-12-31' 
UNION 
SELECT
    '1981'
    , COUNT(id) 
FROM
    players 
WHERE
    birth BETWEEN '1981-1-1' AND '1981-12-31'



--問題71：身長が195㎝より大きいか、体重が95kgより大きい選手を抽出してください。ただし、以下の画像のように、どちらの条件にも合致する場合には2件分のデータとして抽出してください。また、結果はidの昇順としてください。
SELECT
    id
    , position
    , name
    , height
    , weight 
FROM
    players 
WHERE
    height > 195 
UNION ALL 
SELECT
    id
    , position
    , name
    , height
    , weight 
FROM
    players 
WHERE
    weight > 95 
ORDER BY
    id



--問題１：患者名が「鈴木花子」である患者の、最も新しい診察記録の診察ID、診察日、医師名、診療科名を表示するSQL文を作成してください。
SELECT s.examination_id, s.examination_date, d.doctor_name, dp.department_name 
FROM examinations s
JOIN patients p ON s.patient_id = p.patient_id 
JOIN doctors d ON s.doctor_id = d.doctor_id 
JOIN departments dp ON d.department_id = dp.department_id 
WHERE p.patient_name = '鈴木花子' 
LIMIT 1;



--問題2：各診療科ごとに診察回数を集計して、診療科名と診察回数を降順で表示するSQL文を作成してください。
SELECT departments.department_name, COUNT(*) AS count
FROM examinations
INNER JOIN departments
ON examinations.department_id = departments.department_id
GROUP BY departments.department_name
ORDER BY count DESC;


--問題３：医師名が「山田一郎」である患者のIDと患者名を表示するSQL文を作成してください。
SELECT patients.patient_id, patients.patient_name
FROM patients
INNER JOIN examinations
ON patients.patient_id = examinations.patient_id
INNER JOIN doctors
ON examinations.doctor_id = doctors.doctor_id
WHERE doctors.doctor_name = '山田一郎';



--問題４：診療科が「内科」かつ診察日が2022年4月1日以降である患者の患者名と診察日を昇順で表示するSQL文を作成してください。
select p.patient_name, e.examination_date from patients p
inner join examinations e on e.patient_id = p.patient_id
inner join departments d on d.department_id = e.department_id
where d.department_name = '内科' and e.examination_date >='2022-04-01'
order by e.examination_date ASC;



--問題5:医師名が「田中三郎」である診察記録の診察IDと診察日を表示するSQL文を作成してください。
SELECT e.examination_id, e.examination_date
FROM doctors d
INNER JOIN examinations e
ON d.doctor_id = e.doctor_id
WHERE d.doctor_name = '田中三郎';



--問題6:examinationsテーブルから重複を除いた患者(patient_id)の数のSQL文を作成してください。
select distinct patient_id from examinations 



--問題７：department_idが2の科(department)における重複を除いた患者(patient_id)の数のSQL文を作成してください。
SELECT COUNT(DISTINCT patient_id) FROM examinations WHERE department_id = 2;



--問題8：patient_nameが"山田太郎"の患者の情報を取得するクエリを書いてください。
SELECT * from patients p where p.patient_name = '山田太郎';



--問題9.2022年1月1日以降に診察された全ての情報を取得するクエリを書いてください。
SELECT * FROM examinations e where e.examination_date >= '2022-1-1'



--問題１０：patientsテーブルから、patient_idが偶数でかつがgenderは男性の患者の名前を取得するSQL文を作成してください。
SELECT p.patient_name FROM patients p where p.patient_id % 2 =0 and p.gender = '男性'



--問題11：doctorsテーブルから、salaryが400000以上でかつgenderが'女性'の医師のIDと名前を取得するSQL文を作成してください。
SELECT d.doctor_id, d.doctor_name FROM doctors d where d.salary >= '400000' and d.gender = '女性'



--問題１２：department_idが1または2の患者の治療データを取得するSQL文を作成してください。
SELECT * FROM departments d join examinations e on e.department_id = d.department_id 
where d.department_id = '1' or d.department_id = '2'



--問題１３：患者のIDが6以上で、診断結果が"糖尿病"または"高血圧"である診断データを取得するSQL文を作成してください。
SELECT * FROM examinations e where e.patient_id >= '6' and 
(e.diagnosis = '糖尿病' or e.diagnosis = '高血圧')



--問題１４：patient_idが3または4の場合で、かつ、diagnosisに"急性中耳炎"または"風邪"が含まれるレコードを抽出するSQL文を作成してください。
SELECT * FROM examinations e where (e.patient_id = '3' or e.patient_id = '4') and 
(e.diagnosis = '急性中耳炎' or e.diagnosis = '風邪')



--問題１５：patient_idが5で、かつ、(doctor_idが8であるか、department_idが4である)、かつ、examination_dateが2022年11月05日より後のレコー
--          ドを抽出するSQL文を作成してください。
SELECT * FROM examinations
WHERE patient_id = '5' AND ((doctor_id = '8' OR department_id = '4') AND examination_date > '2022-11-05');



--問題16：examination_dateを昇順で並べ替えた結果を取得するSQL文を書いてください。
SELECT * FROM examinations ORDER BY examination_date ASC;



--問題17:diagnosisが"風邪"のレコードをtreatmentの降順で並べ替えた結果を取得するSQL文を書いてください。
SELECT * FROM examinations WHERE diagnosis = '風邪'ORDER BY treatment DESC;



--問題18：最初の5つの患者のIDと名前を取得するSQL文を書いてください。
SELECT patient_id, patient_name
FROM patients
LIMIT 5;



--問題19：患者の診察データで、診断が「風邪」となっている最初の10件のデータを取得するSQL文を書いてください。
SELECT *
FROM examinations
WHERE diagnosis = '風邪'
LIMIT 10;



--問題２０：examinationsテーブルから、患者IDが1であるデータのうち、最も古い日付であるexamination_dateで並び替えた上で、2番目のレコードから4つのレコードを取得してください。
SELECT *
FROM examinations
WHERE patient_id = 11
ORDER BY examination_date ASC
LIMIT 3 OFFSET 1;



--問題21."骨"で始まるdiagnosisを持つ患者を選択するSQL文を書いてください。
SELECT * FROM examinations
WHERE diagnosis LIKE '骨%';



--問題22."慢性中耳炎"という単語を含むdiagnosisを持つ患者を選択するSQL文を書いてください。
SELECT *FROM examinations WHERE diagnosis LIKE '慢性中耳炎';



--23.安静にして湿布を貼るように指示で終わるpatient_idを持つ患者を選択するSQL文を書いてください。
SELECT * FROM examinations WHERE treatment like '安静にして湿布を貼るように指示';



--24.patient_idが3、5、8、10の患者の全診断情報を取得するSQLクエリを作成してください。
SELECT *
FROM examinations
WHERE patient_id IN (3, 5, 8, 10);



--25.患者IDが2, 4, 6, 8のいずれかである診察レコードを検索してください。ただし、診察科が '小児科' であるものに限定します。
select
    * 
from
    examinations e join departments d 
        on d.department_id = e.examination_id 
where
    e.patient_id IN (3, 5, 8, 10) 
    and d.department_name like '小児科';



--26.診察日が2022年3月15日または5月20日であり、診察科が '外科' または '歯科' のいずれかである診察レ
--コードを検索してください。ただし、患者IDが4であるものは除外します。
SELECT * FROM examinations WHERE (examination_date = '2022/03/15' OR examination_date = '2022/05/20')
AND department_id IN (SELECT department_id FROM departments WHERE department_name IN ('外科', '歯科'))
AND patient_id NOT IN (4);

SELECT *
FROM examinations e
JOIN departments d ON e.department_id = d.department_id
WHERE e.examination_date IN ('2022/03/15', '2022/05/20')
AND d.department_name IN ('外科', '歯科')
AND e.patient_id <> 4;



--27.検査日が2022年3月から2022年5月の間にある患者のうち、病院の外来で診察された患者の検査IDと診断結果を取得する。
select e.examination_id, e.diagnosis from examinations e where e.examination_date between '2022-03-01' and '2022-05-31'



--28.検査日が2022年3月から5月の間にある患者で、診断結果に「胃潰瘍」という文字列が含まれている患者
--の検査ID、患者ID、医師ID、診断結果を取得する。
select e.examination_id, e.patient_id, e.doctor_id, e.diagnosis from examinations e where e.examination_date
 between '2022-03-01' and '2022-05-31'
and e.diagnosis like '胃潰瘍';



--29.患者名、性別、診断、治療、および医師名を含む、すべての患者の詳細とその医師の情報を取得するSQL文を作成してください。
select p.patient_name, p.gender, e.diagnosis, d.doctor_name from examinations e join patients p on p.patient_id = e.patient_id
join doctors d on d.doctor_id = e.doctor_id ;



--30.各診療科の診断の数を含む、診療科名と診断数を表示するSQL文を作成してください。
select d.department_name,count(e.examination_id) from examinations e join departments d on d.department_id = e.department_id 
group by d.department_name



--31.医師の情報と診断名を結合し、診断名が "慢性中耳炎" である患者の氏名と診断日を表示するクエリ。
select p.patient_name, e.examination_date from doctors d join examinations e on d.doctor_id = e.doctor_id 
join patients p on p.patient_id = e.patient_id
where e.diagnosis LIKE '慢性中耳炎'



--32.特定の科に所属する医師と、その医師が診断した患者の氏名と診断名を表示するクエリ。
SELECT p.patient_name, e.diagnosis, d.doctor_name as 医師
FROM patients p
INNER JOIN examinations e ON p.patient_id = e.patient_id
INNER JOIN doctors d ON e.doctor_id = d.doctor_id
INNER JOIN departments dep ON d.department_id = dep.department_id
WHERE dep.department_name = '外科';



--33.患者ごとに、彼らが最後に受けた検査の情報と、その検査を行った医師の情報を表示する。
--※（もし患者がまだ検査を受けていない場合は、NULL値が表示してください。）
SELECT p.patient_name, e.examination_date, d.doctor_name, de.department_name
FROM patients p
LEFT JOIN (
  SELECT examination_id, patient_id, doctor_id, department_id, examination_date
  FROM examinations e1
  WHERE NOT EXISTS (
    SELECT 1 
    FROM examinations e2
    WHERE e1.patient_id = e2.patient_id AND e1.examination_date < e2.examination_date
  )
) e ON p.patient_id = e.patient_id
LEFT JOIN doctors d ON e.doctor_id = d.doctor_id
LEFT JOIN departments de ON e.department_id = de.department_id;



----34.各部門ごとに、その部門で働く医師の平均給与と、その部門で行われた検査の数を表示する。
--※部門に医師がいない場合は、平均給与がNULL値として表示してください。また、部門に検査が
--行われていない場合は、検査数が0として表示してください
SELECT de.department_name, AVG(d.salary) AS avg_salary, COUNT(e.examination_id) AS num_exams
FROM departments de
LEFT JOIN doctors d ON de.department_id = d.department_id
LEFT JOIN examinations e ON de.department_id = e.department_id
GROUP BY de.department_id;



--35.departmentsテーブルとdoctorsテーブルをdepartment_idで結合し、各部署の平均給与を取得するSQL文を作成してください。
SELECT departments.department_name, AVG(doctors.salary) AS avg_salary
FROM departments
LEFT JOIN doctors
ON departments.department_id = doctors.department_id
GROUP BY departments.department_name;



--36.patientsテーブルとexaminationsテーブルをpatient_idで結合し、診察を受けた患者の総数と最新の診察日を取得するSQL文を作成してください。
SELECT patients.patient_name, COUNT(examinations.examination_id) AS total_examinations, MAX(examinations.examination_date) AS latest_examination
FROM patients
LEFT JOIN examinations
ON patients.patient_id = examinations.patient_id
GROUP BY patients.patient_name;



--37.医師の情報を、所属する部署の情報がある場合はそれも含めて表示するSQL文を作成してください。
select * from departments dep left join doctors d on d.department_id = dep.department_id



--38.検査の情報を、患者の情報がある場合はそれも含めて表示するSQL文を作成してください。
select * from patients p right join examinations e on e.patient_id = p.patient_id



--39.patientsテーブルとexaminationsテーブルをLEFT JOINし、各患者が最も最近行った検査の情報を取得するクエリを作成してください。
select p.patient_name, max(e.examination_date) from patients p left join examinations e on p.patient_id = e.patient_id group by
p.patient_name



--40.doctorsテーブルとdepartmentsテーブルをLEFT JOINし、各科の平均給与と最低給与を取得するクエリを作成してください。
select dep.department_name, AVG(d.salary), min(d.salary) from doctors d left join departments dep on d.department_id = dep.department_id
group by dep.department_name



--41.医者の名前、患者の名前、診断、治療内容、および診察日を含むレポートを作成してください。ただし、医者と患者がともに存在し、診断と治療内容
--が空でない場合にのみ、レポートに含めてください。レポートは、診察日が新しいものから古いものの順に並べ替える必要があります。
SELECT d.doctor_name, p.patient_name, e.diagnosis, e.treatment, e.examination_date 
FROM examinations e 
JOIN patients p ON e.patient_id = p.patient_id 
JOIN doctors d ON d.department_id = e.department_id 
WHERE e.diagnosis <> '' AND e.treatment <> ''
ORDER BY e.examination_date DESC;


SELECT doctors.doctor_name, patients.patient_name, examinations.diagnosis, examinations.treatment, examinations.examination_date
FROM doctors
INNER JOIN examinations ON doctors.doctor_id = examinations.doctor_id
INNER JOIN patients ON examinations.patient_id = patients.patient_id
WHERE examinations.diagnosis <> '' AND examinations.treatment <> ''
ORDER BY examinations.examination_date DESC;



--42.患者（patients）と医師（doctors）の情報を結合して、部署（departments）ごとの平均給与（salary）を表示するクエリを作成してください。
--ただし、部署名（department_name）が '内科' の部署は除外してください。
SELECT d.department_id, d.department_name, AVG(salary) as avg_salary
FROM departments d
INNER JOIN doctors doc ON doc.department_id = d.department_id
INNER JOIN patients p ON p.gender = doc.gender
WHERE d.department_name <> '内科'
GROUP BY d.department_id, d.department_name;



--43.患者（patients）と検査（examinations）の情報を結合して、患者名（patient_name）と検査日（examination_date）
--ごとの医師数を表示するクエリを作成してください。
--ただし、患者名と検査日の組み合わせが存在しない場合は、0を表示してください。
SELECT p.patient_name, e.examination_date, COUNT(doc.doctor_id) AS doctor_count
FROM patients p
LEFT JOIN examinations e ON p.patient_id = e.patient_id
LEFT JOIN doctors doc ON doc.doctor_id = e.doctor_id
GROUP BY p.patient_name, e.examination_date;



--44.患者と医師の所属科とその科の説明の情報を結合するSQL文を作成して
select p.patient_name,d.department_name,d.description from examinations e join patients p on e.patient_id = p.patient_id
join departments d on d.department_id = e.department_id



--45.患者の性別と年齢情報、医師の性別を結合するSQL文を作成してください。
SELECT p.patient_name, p.gender as patient_gender, p.date_of_birth as patient_dob, d.doctor_name, d.gender as doctor_gender, date_part('year',age(current_date, to_date(p.date_of_birth, 'YYYY-MM-DD'))) as patient_age
FROM patients p
INNER JOIN examinations e ON p.patient_id = e.patient_id
INNER JOIN doctors d ON e.doctor_id = d.doctor_id;



--46.全患者の中で、診断された病気の数が最も多いトップ5の患者を取得するためのクエリを作成してください。
--ただし、診断がない患者は結果に含めないでください。
SELECT p.patient_name, COUNT(*) AS num_diagnoses
FROM patients p
INNER JOIN examinations e ON p.patient_id = e.patient_id
WHERE e.diagnosis IS NOT NULL
GROUP BY p.patient_name
ORDER BY num_diagnoses DESC
LIMIT 5;



--47.医師ごとに、その医師が診察した患者の名前、性別、診察日、診断、および治療を取得するためのクエリを作成してください。
--ただし、全ての医師の情報を取得する必要があります。
SELECT d.doctor_name, p.patient_name, p.gender, e.examination_date, e.diagnosis, e.treatment
FROM doctors d
LEFT JOIN examinations e ON d.doctor_id = e.doctor_id
LEFT JOIN patients p ON e.patient_id = p.patient_id;



--48.医師の平均給与を求める
SELECT AVG(salary) AS avg_salary FROM doctors;



--49.部署ごとの医師の平均給与を求める
SELECT departments.department_name, AVG(doctors.salary) as avg_salary
FROM departments
INNER JOIN doctors ON departments.department_id = doctors.department_id
GROUP BY departments.department_name;



--50.全患者の平均年齢を求める
SELECT AVG(EXTRACT(YEAR FROM NOW()) - EXTRACT(YEAR FROM TO_DATE(patients.date_of_birth, 'YYYY-MM-DD'))) AS avg_age
FROM patients;



--51.examinationsテーブルに登録された、各患者の診察回数を求めるSQL文を作成してください。
SELECT patient_name, COUNT(*) as examination_count
FROM patients
INNER JOIN examinations ON patients.patient_id = examinations.patient_id
GROUP BY patient_name;



--52.患者の数をカウントするSQL文を作成してください。
SELECT COUNT(patient_id) as patient_count FROM patients;



--53.各科の医師数をカウントするSQL文を作成してください。
SELECT COUNT(d.doctor_id) FROM doctors d;



--54.各患者の最も古い検査日を取得する。
SELECT patients.patient_name, MIN(examination_date) AS old_examination_date
FROM examinations inner join patients on examinations.patient_id = patients.patient_id
GROUP BY patient_name;



--55.最低給料を持つ医師を見つける。
select d.doctor_name, min(d.salary) from doctors d group by doctor_name



--56.医師の最高給与を検索するSQL文を作成してください。
SELECT MAX(salary) AS max_salary FROM doctors;



--57.各診療科の医師の最高給与を検索するSQL文を作成してください。
SELECT departments.department_name, MAX(doctors.salary) AS max_salary
FROM departments
INNER JOIN doctors ON departments.department_id = doctors.department_id
GROUP BY departments.department_name;



--58.各患者の最新の診断を検索するSQL文を作成してください。
SELECT patients.patient_name, examinations.diagnosis, MAX(examinations.examination_date) AS latest_diagnosis_date
FROM patients
INNER JOIN examinations ON patients.patient_id = examinations.patient_id
GROUP BY patients.patient_name, examinations.diagnosis;



--59.各部門の医師の平均給与と総支払額を計算するSQL文を作成してください。
select d.doctor_name, avg(d.salary),sum(d.salary) from doctors d group by d.doctor_name



--60.「歯科」所属する医師の給与総額を計算するSQL文を作成してください。
SELECT departments.department_name, SUM(doctors.salary) AS total_salary
FROM departments
INNER JOIN doctors
ON departments.department_id = doctors.department_id
WHERE departments.department_name = '歯科'
GROUP BY departments.department_name;
