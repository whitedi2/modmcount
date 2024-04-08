﻿
&НаКлиенте
Процедура Загрузить(Команда)

	Закрыть(ПутьКФайлу);	
	
КонецПроцедуры

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

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("ВидЗагрузки") Тогда
		ВидЗагрузки = Параметры.ВидЗагрузки;
		Элементы["Пример" + ВидЗагрузки].Видимость = Истина;
	КонецЕсли;	

	Если Параметры.Свойство("Договор") Тогда
		Договор = Параметры.Договор;  
		ТипЦенДоговора = Договор.ТипЦен;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьДанныеПоЗагрузке(ПутьКФайлу) Экспорт
	
	Данные = Неопределено;
	
	ЧислоСтрок = 0;
	КоличествоСтраниц = 1;
	
	XLSОбъект = Новый COMОбъект("Excel.Application");
	ПодключениеКФайлу(ЧислоСтрок, Данные, XLSОбъект, ПутьКФайлу);
	СтруктураВозврата = Новый Структура;
		
	Для счСтроки = 0 по СтрокаОкончания-СтрокаНачала Цикл
		Состояние("Загрузка", счСтроки / (СтрокаОкончания-СтрокаНачала) * 100);
		СтруктураСтроки = Новый Структура;
		СтруктураТекНоменклатуры = НайтиНоменклатуру(СокрЛП(Данные[0][счСтроки]), ТипЦенДоговора);
		
		Если Не ЗначениеЗаполнено(СтруктураТекНоменклатуры.Номенклатура) Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураСтроки.Вставить("Номенклатура", СтруктураТекНоменклатуры.Номенклатура);
		
		Если ВидЗагрузки = "ЗагрузкаВТЧЗаказКлиента" Тогда
			СтруктураСтроки.Вставить("Количество", Данные[1][счСтроки]);
			СтруктураСтроки.Вставить("КоличествоУпаковок", Данные[1][счСтроки]);
			СтруктураСтроки.Вставить("Цена", СтруктураТекНоменклатуры.Цена);
			//СтруктураСтроки.Вставить("КоличествоВЗапайках", Данные[3][счСтроки]);
		Иначе
			СтруктураСтроки.Вставить("Количество", Данные[1][счСтроки]);
			СтруктураСтроки.Вставить("КоличествоУпаковок", Данные[1][счСтроки]);
			СтруктураСтроки.Вставить("ЦенаExel", Данные[3][счСтроки]);
		КонецЕсли; 
		
		Если Не ЗначениеЗаполнено(СтруктураСтроки.Количество) Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураВозврата.Вставить("_" + СтрЗаменить(СтрЗаменить(Строка(счСтроки), " ", ""), Символы.НПП, ""), СтруктураСтроки);
	КонецЦикла;
	
	XLSОбъект.Application.Quit();
	
	Возврат СтруктураВозврата; 
	
КонецФункции
	
&НаКлиенте
Процедура ПодключениеКФайлу(ЧислоСтрок, Данные, XLSОбъект = Неопределено, ПутьКФайлу)
	
	Если Не ЗначениеЗаполнено(ПутьКФайлу) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Укажите путь к файлу!";
		Сообщение.Поле = "Файл";
		Сообщение.Сообщить(); 	
		Возврат;
	КонецЕсли;
	
	Если НЕ ПутьКФайлу = Неопределено Тогда
		
		Если XLSОбъект = Неопределено Тогда
			XLSОбъект = Новый COMОбъект("Excel.Application");
		КонецЕсли;
		
		XLSОбъект.Visible       = Ложь;
		XLSОбъект.DisplayAlerts = Ложь;
		
		Попытка
			Book = XLSОбъект.Workbooks.Open(ПутьКФайлу, , Истина);
		Исключение
			Сообщить ("Проблемы с подключением к Excel" );
		КонецПопытки;
		
		Лист = Book.Sheets(1);
		
		//КонечнаяСтрока = Лист.Cells.SpecialCells(11).Row;
		//ЧислоСтрок = КонечнаяСтрока - 1;
		//Область = Лист.Range(Лист.Cells(1,1), Лист.Cells(КонечнаяСтрока,40));	
		
		Область = Лист.Range(Лист.Cells(СтрокаНачала,1), Лист.Cells(СтрокаОкончания,40));	
		Данные = Область.Value.Выгрузить();      
		
		//!!!!!
		//Данные = Неопределено;
		//Файл = Новый ДвоичныеДанные(ПутьКФайлу);
		//Адрес = ПоместитьВоВременноеХранилище(Файл, ЭтаФорма.УникальныйИдентификатор);
		//
		//Файл1 = Новый Файл(ПутьКФайлу);
		//РасширениеФайла = Файл1.Расширение;
		//
		//Данные = ПрочитатьДанныеФайла(Адрес, 40, РасширениеФайла); 		
		//!!!!!

	КонецЕсли;	
	
КонецПроцедуры 

&НаСервере
Функция ПрочитатьДанныеФайла(Адрес, КолВоКолонокФайла=0, Расширение="xlsx")
	
	МассивДанных = Новый Массив;
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(Адрес);
	
	ПутьКФайлуСервер = КаталогВременныхФайлов() + "123." + Расширение; //для примера...
	ВременныйФайл = Новый Файл(ПутьКФайлуСервер);
	Если ВременныйФайл.Существует() Тогда
		УдалитьФайлы(ПутьКФайлуСервер);
	КонецЕсли;	
	
	ДвоичныеДанные.Записать(ПутьКФайлуСервер);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	Попытка
		// Выполняется долго на больших файлах.
		ТабличныйДокумент.Прочитать(ПутьКФайлуСервер, СпособЧтенияЗначенийТабличногоДокумента.Значение);    // СпособЧтенияЗначенийТабличногоДокумента - новый параметр платформы 8.3.6. Второе значение "Текст".
			
		СписокЛистов = Новый СписокЗначений;
		
		Для Каждого ОбластьТД ИЗ ТабличныйДокумент.Области Цикл
			СписокЛистов.Добавить(ОбластьТД.Имя);
		КонецЦикла;
		
	Исключение
		Сообщить(ОписаниеОшибки(), СтатусСообщения.Внимание);
		Возврат МассивДанных;
	КонецПопытки;
	
	Данные = ТабличныйДокумент.ПолучитьОбласть(СписокЛистов[0].Значение);
	КолВоСтрокФайла = Данные.ПолучитьРазмерОбластиДанныхПоВертикали();
	Если КолВоКолонокФайла = 0 Тогда
	КолВоКолонокФайла = Данные.ПолучитьРазмерОбластиДанныхПоГоризонтали();
	КонецЕсли;
	
	
	Для НомерКолонки = 1 По КолВоКолонокФайла Цикл//КолВоКолонокФайла Цикл
		
		МассивСтолбец = Новый Массив;
		
		Для НомерСтроки = 1 По КолВоСтрокФайла Цикл
			ОбластьЯчейка = Данные.ПолучитьОбласть("R"+НомерСтроки+"C"+НомерКолонки);
			ТекОбласть = ОбластьЯчейка.ТекущаяОбласть;
			Попытка
				ЗначениеЯчейки = ТекОбласть.Значение;        // Число, Дата.
			Исключение
				ЗначениеЯчейки = СокрЛП(ТекОбласть.Текст);    // Строка, Булево. (Булево как строка "ИСТИНА"/"ЛОЖЬ")
			КонецПопытки;
			
			МассивСтолбец.Добавить(ЗначениеЯчейки);
			
		КонецЦикла;
		МассивДанных.Добавить(МассивСтолбец);
	КонецЦикла;	
	
	Возврат МассивДанных;
	
КонецФункции

&НаСервереБезКонтекста
Функция НайтиНоменклатуру(НаименованиеНоменклатуры, ТипЦенДоговора)
	
    СтруктураВозврата = Новый Структура("Номенклатура, Цена", Справочники.Номенклатура.ПустаяСсылка(), 0);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ВТ_НайденнаяНоменклатура
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Наименование = &Наименование
	|	И Номенклатура.ЭтоГруппа = ЛОЖЬ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	isnull(ЦеныНоменклатурыСрезПоследних.Цена, 0) КАК Цена,
	|	ВТ_НайденнаяНоменклатура.Ссылка КАК Номенклатура
	|ИЗ
	|	ВТ_НайденнаяНоменклатура КАК ВТ_НайденнаяНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	|				,
	|				ВЫБОР
	|					КОГДА &ТипЦенДоговора = НЕОПРЕДЕЛЕНО
	|						ТОГДА ЛОЖЬ
	|					ИНАЧЕ ТипЦен = &ТипЦенДоговора
	|				КОНЕЦ) КАК ЦеныНоменклатурыСрезПоследних
	|		ПО ВТ_НайденнаяНоменклатура.Ссылка = ЦеныНоменклатурыСрезПоследних.Номенклатура";
	Запрос.УстановитьПараметр("Наименование", НаименованиеНоменклатуры); 
	Запрос.УстановитьПараметр("ТипЦенДоговора", ?(ЗначениеЗаполнено(ТипЦенДоговора), ТипЦенДоговора, Неопределено));
	
	Результат = Запрос.Выполнить();	
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда  
		СтруктураВозврата.Номенклатура = Выборка.Номенклатура;
		СтруктураВозврата.Цена = Выборка.Цена;
	КонецЕсли;
	
	Возврат СтруктураВозврата;
	
КонецФункции

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
		XLSОбъект.Application.Quit();
	КонецЕсли;

КонецПроцедуры
