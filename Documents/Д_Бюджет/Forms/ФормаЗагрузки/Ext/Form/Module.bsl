﻿
&НаКлиенте
Процедура ПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДиалогВыбораФайла =	Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла.Фильтр		 = "Файл Excel (*.xls)|*.xls*";
	ДиалогВыбораФайла.Расширение	 = "xls";
	ДиалогВыбораФайла.Заголовок		 = "Выберите файл";
	ДиалогВыбораФайла.ПолноеИмяФайла = ПутьКФайлу;
	Если ДиалогВыбораФайла.Выбрать() Тогда
		ПутьКФайлу = ДиалогВыбораФайла.ПолноеИмяФайла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Загрузить(Команда)
	
	Если НЕ ЗначениеЗаполнено(ПутьКФайлу) ИЛИ Не ЗначениеЗаполнено(СтрокаНачала) Или НЕ ЗначениеЗаполнено(СтрокаОкончания) Тогда
		Сообщить("Не указан путь, либо параметры начала и окончания загрузки."); 	
	Иначе  	
				
		XLSОбъект = Новый COMОбъект("Excel.Application");
		XLSОбъект.Visible       = Ложь;
		XLSОбъект.DisplayAlerts = Ложь;
		
		Попытка
			Book = XLSОбъект.Workbooks.Open(ПутьКФайлу, , Истина);
		Исключение
			Сообщить ("Проблемы с подключением к Excel" );
		КонецПопытки;
		
		Лист = Book.Sheets(1);
		
		//Получааем количество строк в книге
		//ВсегоСтрок = Лист.UsedRange.Rows.Count;
		
		Область = Лист.Range(Лист.Cells(СтрокаНачала,1), Лист.Cells(СтрокаОкончания,40));	
		
		//получаем массив колонок)))
		Данные = Область.Value.Выгрузить();
		//ДанныеКонтрагент = Данные[6];
		 		
				
		ТЧ = ПолучитьУпрФорму(ВладелецФормы).Объект[ВладелецФормы.Имя];
		
		ЗаполнитьПредприятияСервер();
		
		Для ТекСтрока = 0 по СтрокаОкончания - СтрокаНачала - 1 Цикл
			
			ТекКол = ?(ПустаяСтрока(Данные[11][ТекСтрока]), 0, Число(Данные[11][ТекСтрока]));
			ТекПостл = ?(ПустаяСтрока(Данные[29][ТекСтрока]), 0, Число(Данные[29][ТекСтрока]));
			ДЗНач = ?(ПустаяСтрока(Данные[9][ТекСтрока]), 0, Число(Данные[9][ТекСтрока]));
			
			Если НЕ ТекКол И НЕ ТекПостл И НЕ ДЗНач Тогда
				Продолжить;
			КонецЕсли;
			
			
			ПредприятиеЗагрузка = НайтиПредприятие(Строка(Данные[1][ТекСтрока]));
			Если НЕ Предприятие = ПредприятиеЗагрузка Тогда
				Продолжить;
			КонецЕсли;
			
			Контрагент = НайтиКонтрагента(Строка(Данные[5][ТекСтрока]), Предприятие);
			Подразделение = НайтиПодразделение(Строка(Данные[6][ТекСтрока]), Предприятие);
			Номенклатура = НайтиНоменклатуру(Строка(Данные[7][ТекСтрока]), Предприятие);
			
			Если ПустаяСтрока(Подразделение) Тогда
				Сообщить("Подразделение " + Строка(Данные[6][ТекСтрока]) + " не найдено");
			КонецЕсли;
			
			Если НЕ БюджетныйНаСервере.ВернутьРеквизит(Предприятие, "ПроизводственноеПредприятие") = Ложь Тогда
				Если ПустаяСтрока(Номенклатура) Тогда
					Сообщить("Номенклатура " + Строка(Данные[7][ТекСтрока]) + " не найдена");
				КонецЕсли;
			КонецЕсли;			
			
			////добавляем запись в табличную часть
			СтрокаТЧ = ТЧ.Добавить();
			СтрокаТЧ.Контрагент = Контрагент;
			СтрокаТЧ.Подразделение = Подразделение;
			СтрокаТЧ.Номенклатура = Номенклатура;
			СтрокаТЧ.ДЗНачало = Данные[9][ТекСтрока];
			СтрокаТЧ.Количество = Данные[11][ТекСтрока];
			
			Попытка
				Данные[13][ТекСтрока] = Число(Данные[13][ТекСтрока]);
			Исключение
			    Данные[13][ТекСтрока] = 0;
			КонецПопытки;
			
			Попытка
				Данные[14][ТекСтрока] = Число(Данные[14][ТекСтрока]);
			Исключение
				Данные[14][ТекСтрока] = 0;
			КонецПопытки;
			
			Попытка
				Данные[17][ТекСтрока] = Число(Данные[17][ТекСтрока]);
			Исключение
				Данные[17][ТекСтрока] = 0;
			КонецПопытки;
			
			Попытка
				Данные[18][ТекСтрока] = Число(Данные[18][ТекСтрока]);
			Исключение
				Данные[18][ТекСтрока] = 0;
			КонецПопытки; 
			
			
			
			
			//Если Нрег(Данные[20][ТекСтрока]) = "сверх цены" Тогда
			//	Цена = Данные[13][ТекСтрока] - Данные[14][ТекСтрока] ;
			//Иначе
			//	Цена = Данные[13][ТекСтрока] - Данные[17][ТекСтрока] - Данные[18][ТекСтрока] - Данные[14][ТекСтрока];
			//КонецЕсли;
			 
			СтрокаТЧ.Цена = Данные[13][ТекСтрока];
			СтрокаТЧ.Верх = Данные[14][ТекСтрока];
			СтрокаТЧ.ЖД   = Данные[17][ТекСтрока];
			СтрокаТЧ.Авто = Данные[18][ТекСтрока];
			СтрокаТЧ.ВозмещениеТр  = НРег(Данные[19][ТекСтрока]);
			СтрокаТЧ.ВозмещениеТр2 = НРег(Данные[20][ТекСтрока]);
			СтрокаТЧ.Предоплата = Данные[27][ТекСтрока];
			СтрокаТЧ.Отсрочка = Данные[28][ТекСтрока];
			СтрокаТЧ.ПоступлениеДС = Данные[29][ТекСтрока];
			//СтрокаТЧ.ТекущиеДанные.Покупной = Транзит(Данные[29][ТекСтрока]);
			СтрокаТЧ.СтатьяБДДС = СтатьяДДС(Данные[31][ТекСтрока]);
			СтрокаТЧ.ЦенаЗакупки = Данные[15][ТекСтрока];
			
			Если Данные[30][ТекСтрока] = "Собств. пр-ва" Тогда
				СтрокаТЧ.Покупной = Транзит("транзит");
			ИначеЕсли Данные[30][ТекСтрока] = "Закупной" Тогда
				СтрокаТЧ.Покупной = Транзит("закупной");
			ИначеЕсли Данные[30][ТекСтрока] = "Закуп. товар" Тогда
				СтрокаТЧ.Покупной = Транзит("Закуп товар");
			ИначеЕсли Данные[30][ТекСтрока] = "Закуп. билет" Тогда
				СтрокаТЧ.Покупной = Транзит("Закуп билет");
			ИначеЕсли Данные[30][ТекСтрока] = "Закуп. тур. услуга" Тогда
				СтрокаТЧ.Покупной = Транзит("Закуп тур услуга");	
			КонецЕсли;	
			
			СтрокаТЧ.Месяц = Дата(СокрЛП(Данные[0][ТекСтрока]));

			
			
			//счСтроки = счСтроки + 1;
		КонецЦикла;
		
		XLSОбъект.Application.Quit();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СтатьяДДС(КодСтатьи)
	Возврат Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоКоду(КодСтатьи);
КонецФункции // ()
 

&НаСервереБезКонтекста
Функция Транзит(Признак)
	Если Признак = "транзит" Тогда
		Возврат Перечисления.Д_ПокупнойСпирт.Транзитный;
	иначеЕсли Признак = "закупной" Тогда
		Возврат Перечисления.Д_ПокупнойСпирт.Закупной;
	ИначеЕсли Признак = "Закуп товар" Тогда
		Возврат Перечисления.Д_ПокупнойСпирт.ЗакупТовар
	ИначеЕсли Признак = "Закуп билет" Тогда
		Возврат Перечисления.Д_ПокупнойСпирт.ЗакупБилет
	ИначеЕсли Признак = "Закуп тур услуга" Тогда
		Возврат Перечисления.Д_ПокупнойСпирт.ЗакупТурУслуга
	Иначе
		Возврат "";
	КонецЕсли;
КонецФункции // ()


&НаСервере
Функция НайтиКонтрагента(Наименование, Предприятие)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Контрагенты.Ссылка
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.Предприятия.Предприятие В(&Предприятие)
	|	И Контрагенты.Наименование = &Наименование";
	
	Запрос.УстановитьПараметр("Предприятие", Предприятие);
	Запрос.УстановитьПараметр("Наименование", Наименование);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		УжеСуществует = Выборка.Ссылка;
	Иначе
		УжеСуществует = Наименование;
	КонецЕсли;
	Возврат УжеСуществует;
КонецФункции

&НаСервере
Функция НайтиПредприятие(Наименование)
	ОтобранныеПП = Предприятия.НайтиСтроки(Новый Структура("Наименование", Наименование));  
	
	Для каждого ТекПП Из ОтобранныеПП Цикл
		Возврат ТекПП.Предприятие;	
	КонецЦикла; 
	
	Возврат Справочники.Предприятия.ПустаяСсылка();
КонецФункции

&НаСервере
Процедура ЗаполнитьПредприятияСервер()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Предприятия.Ссылка КАК Предприятие,
	               |	Предприятия.Наименование
	               |ИЗ
	               |	Справочник.Предприятия КАК Предприятия";
	
	
	Результат = Запрос.Выполнить();
	Предприятия.Загрузить(Результат.Выгрузить());
	
КонецПроцедуры


&НаСервере
Функция НайтиНоменклатуру(Номенклатура, Предприятие)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Номенклатура.Ссылка
	               |ИЗ
	               |	Справочник.Номенклатура КАК Номенклатура
	               |ГДЕ
	               |	Номенклатура.Предприятие = &Предприятие
	               |	И Номенклатура.Наименование = &Наименование
	               |	И Номенклатура.ПометкаУдаления = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("Предприятие", Предприятие);
	Запрос.УстановитьПараметр("Наименование", Номенклатура);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		УжеСуществует = Выборка.Ссылка;
	Иначе
		УжеСуществует = Справочники.Номенклатура.ПустаяСсылка();
	КонецЕсли;
	Возврат УжеСуществует;
КонецФункции

&НаСервере
Функция НайтиПодразделение(Подразделение, Предприятие)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВидыДеятельности.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.СтруктураПредприятия КАК ВидыДеятельности
	               |ГДЕ
	               |	ВидыДеятельности.ПометкаУдаления = ЛОЖЬ
	               |	И ВидыДеятельности.Владелец = &Предприятие
	               |	И ВидыДеятельности.Наименование = &Наименование";
	
	Запрос.УстановитьПараметр("Предприятие", Предприятие);
	Запрос.УстановитьПараметр("Наименование", Подразделение);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		ТекПодр = Выборка.Ссылка;
	Иначе
		ТекПодр = Справочники.СтруктураПредприятия.ПустаяСсылка();
	КонецЕсли;
	Возврат ТекПодр;
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Предприятие = Параметры.Предприятие;
	Месяцы = Параметры.Месяцы;
КонецПроцедуры

&НаКлиенте
Процедура Рассчитать(Команда)
	Если НЕ ЗначениеЗаполнено(ПутьКФайлу) Тогда
		Сообщить("Не указан путь к файлу."); 	
	Иначе  	
		
		XLSОбъект = Новый COMОбъект("Excel.Application");
		XLSОбъект.Visible       = Ложь;
		XLSОбъект.DisplayAlerts = Ложь;
		
		Попытка
			Book = XLSОбъект.Workbooks.Open(ПутьКФайлу, , Истина);
		Исключение
			Сообщить ("Проблемы с подключением к Excel" );
		КонецПопытки;
		
		Лист = Book.Sheets(1);
		
		//Получааем количество строк в книге
		СтрокаОкончания = Лист.UsedRange.Rows.Count;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ПолучитьУпрФорму(ТекЭлемент)
	
	Если ТипЗнч(ТекЭлемент.Родитель) = Тип("УправляемаяФорма") Тогда
		Возврат ТекЭлемент.Родитель;
	Иначе 
		Возврат ПолучитьУпрФорму(ТекЭлемент.Родитель);
	КонецЕсли;
	
КонецФункции	

 


