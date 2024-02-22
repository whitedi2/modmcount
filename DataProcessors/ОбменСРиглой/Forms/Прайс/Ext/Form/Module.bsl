﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ТипЦен = Параметры.ТипЦен;
	ПутьПрайса = Параметры.ПутьПрайса;
КонецПроцедуры

&НаКлиенте
Процедура ПодборТоваров(Команда)
	ОписаниеВыбора = Новый ОписаниеОповещения("ОбработатьВыборНоменклатуры",ЭтаФорма);
	
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаДляПодбора",,,,,,
	ОписаниеВыбора,
	РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаСервере
Процедура ОбработатьВыборНоменклатуры(РезультатЗакрытия,ДопПараметры) Экспорт
	
	Если Не ЗначениеЗаполнено(РезультатЗакрытия) Тогда
		Возврат;
	КонецЕсли;
	
	Данные = ПолучитьИзВременногоХранилища(РезультатЗакрытия);
	
	Для каждого Стр Из Данные Цикл
		ПрСтр = Объект.ПрайсЛист.Добавить();
		ПрСтр.CODEPST = СокрЛП(Стр.Номенклатура.Код);
		ПрСтр.NAME = СокрЛП(Стр.Номенклатура.Наименование);
		ПрСтр.QNT = ПолучитьОстаток(Стр.Номенклатура,Склад);
		ПрСтр.PRICE = ПолучитьЦену(Стр.Номенклатура,ТипЦен);
		
		Если ЗначениеЗаполнено(Справочники.Номенклатура.СтавкаНДС(Стр.Номенклатура, ТекущаяДата())) Тогда
			СокрСтавка = Лев(Справочники.Номенклатура.СтавкаНДС(Стр.Номенклатура, ТекущаяДата()),2);
			Если (СокрСтавка = "0%") ИЛИ (СокрСтавка = "Бе") Тогда
				СтавкаНДС = 0;
			Иначе 
				СтавкаНДС = Число(СокрСтавка);	
			КонецЕсли;			
		КонецЕсли;
		ПрСтр.NDS = СтавкаНДС;
		
		//ПрСтр.GDATE = "СрокГодности";
		ПрСтр.EAN13 = ПолучитьШтрихКод(Стр.Номенклатура);
		ПрСтр.FIRM = Стр.Номенклатура.Производитель.Наименование;
		ПрСтр.REESTR = Число(0.00);
		ПрСтр.QNTPACK = Стр.Номенклатура.МинимальнаяПартия;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьОстаток(Номенклатура,Склад)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|   ХозрасчетныйОстатки.Счет,
	|   ХозрасчетныйОстатки.Субконто1 КАК Товар,
	|   ХозрасчетныйОстатки.КоличествоОстатокДт,
	|   ХозрасчетныйОстатки.СуммаОстатокДт        
	|ИЗ
	|   РегистрБухгалтерии.Хозрасчетный.Остатки(
	|       &Дата,
	|       Счет В ИЕРАРХИИ (&ВыбСчет), ,Субконто1 = &Номенклатура
	|   ) КАК ХозрасчетныйОстатки";
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Дата",ТекущаяДата());
	Запрос.УстановитьПараметр("ВыбСчет", ПланыСчетов.Хозрасчетный.Товары);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Записи = РезультатЗапроса.Выбрать();
	
	Пока Записи.Следующий() Цикл
		
		Возврат Записи.КоличествоОстатокДт;
		
	КонецЦикла;
	
КонецФункции

&НаСервере
Функция ПолучитьЦену(Номенклатура,ТипЦен)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|    ЦеныНоменклатурыСрезПоследних.Номенклатура КАК Номенклатура,
	|    ЦеныНоменклатурыСрезПоследних.Цена КАК Цена,
	|     ЦеныНоменклатурыСрезПоследних.Номенклатура.Ссылка
	|ИЗ
	|    РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&Дата, ТипЦен=&ТипЦен)
	|КАК 
	|    ЦеныНоменклатурыСрезПоследних
	|ГДЕ
	|    ЦеныНоменклатурыСрезПоследних.Номенклатура.Ссылка = &Номенклатура";
	
	Запрос.УстановитьПараметр("Номенклатура",Номенклатура);
	Запрос.УстановитьПараметр("Дата",ТекущаяДата());
	Запрос.УстановитьПараметр("ТипЦен",ТипЦен);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() тогда
		Возврат Выборка.Цена;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПолучитьШтрихКод(Номенклатура)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ШтрихкодыНоменклатуры.Штрихкод КАК Штрихкод
	|ИЗ
	|	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|ГДЕ
	|	ШтрихкодыНоменклатуры.Номенклатура.Ссылка = &Номенклатура";
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.Штрихкод;
	КонецЦикла;
	
КонецФункции

&НаКлиенте
Процедура Очистить(Команда)
	Объект.ПрайсЛист.Очистить();
КонецПроцедуры

&НаКлиенте
Процедура Выгрузить(Команда)
	// Запись данных справочника в DBF-файл:
	БД = Новый XBase;
	
	БД.Кодировка = КодировкаXBase.OEM; 
	
	// проектируется структура таблицы, т.е. имена и типы полей
	БД.Поля.Добавить("CODEPST","S",20);
	БД.Поля.Добавить("NAME","S",150);
	БД.Поля.Добавить("QNT","N",20,0);
	БД.Поля.Добавить("PRICE","N",15,2);
	БД.Поля.Добавить("NDS","N",2,0);
	БД.Поля.Добавить("GDATE","D");
	БД.Поля.Добавить("EAN13","N",13,0);
	БД.Поля.Добавить("FIRM","S",80);
	БД.Поля.Добавить("REESTR","N",15,2);
	БД.Поля.Добавить("QNTPACK","N",20,0);
	
	// создание файла с указанной структурой
	ИмяПромежуточногоФайла = ПолучитьИмяВременногоФайла("dbf");
	
	Генератор = Новый ГенераторСлучайныхЧисел;
	ЧастьИмениФайла = Формат(Генератор.СлучайноеЧисло(10000,99999), "ЧГ=");
	ИмяПромежуточногоФайла = Лев(ИмяПромежуточногоФайла,СтрНайти(ИмяПромежуточногоФайла,"v8_")+2)+ЧастьИмениФайла+".dbf";
	
	БД.СоздатьФайл(ИмяПромежуточногоФайла);
		
	Для каждого Стр Из Объект.ПрайсЛист Цикл
		
		// создается новая пустая строка таблицы
		БД.Добавить();
		// заполняем поля новой строки
		БД.CODEPST = Стр.CODEPST;
		БД.NAME = Стр.NAME;
		БД.QNT = Стр.QNT;
		БД.PRICE = Стр.PRICE;
		БД.NDS = Стр.NDS;
		//БД.GDATE = Стр.GDATE;
		БД.EAN13 = Стр.EAN13;
		БД.FIRM = Стр.FIRM;
		БД.REESTR = Стр.REESTR;
		БД.QNTPACK = Стр.QNTPACK;
			
	КонецЦикла;
	
	БД.Записать();
	
	БД.ЗакрытьФайл();
	
	Форма = ПолучитьФорму("Обработка.ОбменСРиглой.Форма.Форма",,, );
  Соединение = Форма.ПодключитьсяКFTPСерверу();
	
	Попытка
		Соединение.Записать(ИмяПромежуточногоФайла, ПутьПрайса+Прав(ИмяПромежуточногоФайла,12));
		Сообщить("Выгрузка прайса завершена: "+ПутьПрайса+Прав(ИмяПромежуточногоФайла,12));
	Исключение
		Сообщить("Ошибка выгрузки прайса");
	КонецПопытки;
	
КонецПроцедуры
