﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДокументПодбора", "");
	ПараметрыФормы.Вставить("КоличествоПодбора", "");
	ЗаполнитьЗначенияСвойств(ПараметрыФормы,Параметры);

	Если Параметры.Свойство("ЭтоСбор") Тогда
		Если Параметры.Свойство("Счет") Тогда
			Если ЗначениеЗаполнено(Параметры.Счет) Тогда
				Счет = Параметры.Счет; 
			Иначе
				Счет = ПланыСчетов.Учетный.НайтиПоКоду("41");
			КонецЕсли;
		Иначе  
			Счет = ПланыСчетов.Учетный.НайтиПоКоду("41"); 
		КонецЕсли;
		Если Параметры.Свойство("ЭтоВыпускПродукции") Тогда
			Если Параметры.ЭтоВыпускПродукции Тогда
				Счет = ПланыСчетов.Учетный.НайтиПоКоду("43");
			КонецЕсли;
		КонецЕсли;
		Если НЕ сабОбщегоНазначенияПовтИсп.ПолучитьНаличиеСерийногоУчетаДляСчета(Счет) Тогда 
			Список.ТекстЗапроса = "ВЫБРАТЬ
			|	СерииНоменклатуры.Ссылка КАК Ссылка,
			|	СерииНоменклатуры.ПометкаУдаления КАК ПометкаУдаления,
			|	СерииНоменклатуры.Владелец КАК Владелец,
			|	ВЫБОР
			|		КОГДА СерииНоменклатуры.ДатаПроизводства = ДАТАВРЕМЯ(1, 1, 1)
			|			ТОГДА СерииНоменклатуры.Наименование
			|		ИНАЧЕ СерииНоменклатуры.ДатаПроизводства
			|	КОНЕЦ КАК Наименование,
			|	СерииНоменклатуры.Предопределенный КАК Предопределенный,
			|	СерииНоменклатуры.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных,
			|	СерииНоменклатуры.ДатаПроизводства КАК ДатаПроизводства,
			|	СерииНоменклатуры.ГоденДо КАК ГоденДо
			|ИЗ
			|	Справочник.СерииНоменклатуры КАК СерииНоменклатуры";
		Иначе
			Если Параметры.Отбор.Свойство("Владелец") Тогда
				//Если Не Параметры.Отбор.Владелец.ИспользоватьСерииНоменклатуры Тогда
				//	СообщениеПользователю = НСтр("ru = 'Учет серий по данной номенклатуре не ведется'");
				//	ОбщегоНазначения.СообщитьПользователю(СообщениеПользователю, , , , Отказ);
				//	Возврат;
				//КонецЕсли;
				
				СсылкаВладелец = Параметры.Отбор.Владелец;
				
				ЭтотОбъект.Заголовок = СтрШаблон(НСтр("ru = 'Серии номенклатуры %1'"), СсылкаВладелец);
				
				//ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДатаПроизводства", "Видимость", СсылкаВладелец.ИспользоватьДатуПроизводстваСерии);
				//ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГоденДо", "Видимость", СсылкаВладелец.ИспользоватьСрокГодностиСерии);
				
				//ТочностьУказанияСрокаГодностиСерии = СсылкаВладелец.ТочностьУказанияСрокаГодностиСерии;
				
				//Если ЗначениеЗаполнено(ТочностьУказанияСрокаГодностиСерии) Тогда
				//	Если ТочностьУказанияСрокаГодностиСерии = Перечисления.ТочностиУказанияСрокаГодности.СТочностьюДоДней Тогда
				//		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДатаПроизводства", "Формат", "ДФ=дд.ММ.гггг");
				//		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГоденДо", "Формат", "ДФ=дд.ММ.гггг");
				//	Иначе
				//		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДатаПроизводства", "Формат", "ДФ='дд.ММ.гггг ЧЧ:мм'");
				//		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГоденДо", "Формат", "ДФ='дд.ММ.гггг ЧЧ:мм'");
				//	КонецЕсли;
				//Иначе
				//	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДатаПроизводства", "Формат", "ДФ=дд.ММ.гггг");
				//	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГоденДо", "Формат", "ДФ=дд.ММ.гггг");
				//КонецЕсли;
				Номенклатура = Неопределено;	
			ИначеЕсли Параметры.Свойство("ТекущаяСтрока") И ЗначениеЗаполнено(Параметры.ТекущаяСтрока) Тогда
				ЭтотОбъект.Заголовок = СтрШаблон(НСтр("ru = 'Серии номенклатуры %1'"), Параметры.ТекущаяСтрока.Владелец); 
				//ПЕ+
				Номенклатура = Параметры.ТекущаяСтрока.Владелец;
				//ПЕ-
			КонецЕсли;
			
			Если Параметры.Свойство("ПоказатьПроданные") Тогда
				ПоказатьПроданные = Параметры.ПоказатьПроданные;
			Иначе
				ПоказатьПроданные = Ложь;
			КонецЕсли;
			
			Если Параметры.Свойство("ПодборДляОплаты") Тогда
				ПодборДляОплаты = Параметры.ПодборДляОплаты;
				Элементы.ПоказатьПроданные.Видимость = Не ПодборДляОплаты;
			КонецЕсли;
			
			Дата = ТекущаяДата();                             
			Предприятие = Неопределено;
			Склад = Неопределено; 
			
			//ПЕ+
			Если Параметры.Свойство("ЗаказКлиента") Тогда
				Если ЗначениеЗаполнено(Параметры.ЗаказКлиента) Тогда
					Предприятие = Параметры.ЗаказКлиента.Предприятие;
					Склад = Параметры.ЗаказКлиента.Склад;  
				КонецЕсли;
			КонецЕсли;
			
			Если Параметры.Свойство("Склад") Тогда
				Если ЗначениеЗаполнено(Параметры.Склад) Тогда
					Склад = Параметры.Склад;  
				КонецЕсли;
			КонецЕсли;
			
			Если Параметры.Свойство("Предприятие") Тогда
				Если ЗначениеЗаполнено(Параметры.Предприятие) Тогда
					Предприятие = Параметры.Предприятие;
				КонецЕсли;
			КонецЕсли;
			
			Если Параметры.Свойство("ДатаОтгрузки") Тогда
				Если ЗначениеЗаполнено(Параметры.ДатаОтгрузки) Тогда
					Дата = КонецДня(Параметры.ДатаОтгрузки);
				КонецЕсли;
			КонецЕсли;
			//СчетТовары = ПланыСчетов.Учетный.НайтиПоКоду("41");
			МассивСубконто = Новый Массив;
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	УчетныйВидыСубконто.ВидСубконто КАК ВидСубконто,
			|	УчетныйВидыСубконто.ВидСубконто.ТипЗначения КАК ТипЗначения
			|ИЗ
			|	ПланСчетов.Учетный.ВидыСубконто КАК УчетныйВидыСубконто
			|ГДЕ
			|	УчетныйВидыСубконто.Ссылка = &Счет";
			Запрос.УстановитьПараметр("Счет",Счет);
			РезультатЗапроса = Запрос.Выполнить();
			ВыборкаТипСубконто = РезультатЗапроса.Выбрать();
			МассивСубконто = Новый Массив;
			Пока ВыборкаТипСубконто.Следующий() Цикл
				Если ВыборкаТипСубконто.ТипЗначения.СодержитТип(Тип("СправочникСсылка.Номенклатура")) ИЛИ 
					ВыборкаТипСубконто.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ОсновныеСредства")) Тогда
					МассивСубконто.Вставить(0, ВыборкаТипСубконто.ВидСубконто);
				ИначеЕсли ВыборкаТипСубконто.ТипЗначения.СодержитТип(Тип("СправочникСсылка.Склады")) Тогда
					МассивСубконто.Вставить(1, ВыборкаТипСубконто.ВидСубконто);
				ИначеЕсли ВыборкаТипСубконто.ТипЗначения.СодержитТип(Тип("СправочникСсылка.СерииНоменклатуры")) Тогда
					МассивСубконто.Вставить(2, ВыборкаТипСубконто.ВидСубконто);
				КонецЕсли;
			КонецЦикла; 
			Список.Параметры.УстановитьЗначениеПараметра("ПоказатьПроданные", ПоказатьПроданные);
			//Список.Параметры.УстановитьЗначениеПараметра("ПодборДляОплаты", ПодборДляОплаты);
			Список.Параметры.УстановитьЗначениеПараметра("Дата", Дата);
			Список.Параметры.УстановитьЗначениеПараметра("Предприятие", Предприятие);
			Список.Параметры.УстановитьЗначениеПараметра("Склад", Склад);
			//ПЕ+
			//Список.Параметры.УстановитьЗначениеПараметра("МассивСубконто", МассивСубконто); //Белых. Это точно нужно? С ограниченными правами выдавало ошибку соед с ТЧ
			Список.Параметры.УстановитьЗначениеПараметра("Номенклатура", Номенклатура);
			Список.Параметры.УстановитьЗначениеПараметра("Счет", Счет);
			//ПЕ-
			//Элементы.Продан.Видимость = ПоказатьПроданные;
			ПоказатьПроданные = Ложь;
			Элементы.Продан.Видимость = ПоказатьПроданные; 
		КонецЕсли;
	Иначе
		МассивСчетов = Новый Массив;
		ЕстьСчетаСерийногоУчета = Ложь;
		Если Параметры.Свойство("Счет") Тогда
			Если ЗначениеЗаполнено(Параметры.Счет) Тогда
				Счет = Параметры.Счет; 
				ЕстьСчетаСерийногоУчета = сабОбщегоНазначенияПовтИсп.ПолучитьНаличиеСерийногоУчетаДляСчета(Счет);
			Иначе
				ПолучитьМассивСчетов(МассивСчетов);
			КонецЕсли;
		Иначе  
			ПолучитьМассивСчетов(МассивСчетов);
		КонецЕсли;
		Если МассивСчетов.Количество() > 0 Тогда
			Счет = МассивСчетов;
			ЕстьСчетаСерийногоУчета = Истина;
		КонецЕсли;
		Если НЕ ЕстьСчетаСерийногоУчета Тогда
			Список.ТекстЗапроса = "ВЫБРАТЬ
			|	СерииНоменклатуры.Ссылка КАК Ссылка,
			|	СерииНоменклатуры.ПометкаУдаления КАК ПометкаУдаления,
			|	СерииНоменклатуры.Владелец КАК Владелец,
			|	ВЫБОР
			|		КОГДА СерииНоменклатуры.ДатаПроизводства = ДАТАВРЕМЯ(1, 1, 1)
			|			ТОГДА СерииНоменклатуры.Наименование
			|		ИНАЧЕ СерииНоменклатуры.ДатаПроизводства
			|	КОНЕЦ КАК Наименование,
			|	СерииНоменклатуры.Предопределенный КАК Предопределенный,
			|	СерииНоменклатуры.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных,
			|	СерииНоменклатуры.ДатаПроизводства КАК ДатаПроизводства,
			|	СерииНоменклатуры.ГоденДо КАК ГоденДо
			|ИЗ
			|	Справочник.СерииНоменклатуры КАК СерииНоменклатуры";
		Иначе
			Если Параметры.Отбор.Свойство("Владелец") Тогда
				СсылкаВладелец = Параметры.Отбор.Владелец;
				ЭтотОбъект.Заголовок = СтрШаблон(НСтр("ru = 'Серии номенклатуры %1'"), СсылкаВладелец);
				Номенклатура = Неопределено;
				Если Параметры.Свойство("ДокументСсылка") И ЗначениеЗаполнено(Параметры.ДокументСсылка) Тогда
					Дата = Параметры.ДокументСсылка.МоментВремени();	
				Иначе
					Дата = ТекущаяДата();				
				КонецЕсли;
			ИначеЕсли Параметры.Свойство("ТекущаяСтрока") И ЗначениеЗаполнено(Параметры.ТекущаяСтрока) Тогда
				ЭтотОбъект.Заголовок = СтрШаблон(НСтр("ru = 'Серии номенклатуры %1'"), Параметры.ТекущаяСтрока.Владелец); 
				Номенклатура = Параметры.ТекущаяСтрока.Владелец;
				Дата = ТекущаяДата();				
			КонецЕсли;
			
			Если Параметры.Свойство("ПоказатьПроданные") Тогда
				ПоказатьПроданные = Параметры.ПоказатьПроданные;
			Иначе
				ПоказатьПроданные = Ложь;
			КонецЕсли;
			
			Если Параметры.Свойство("ПодборДляОплаты") Тогда
				ПодборДляОплаты = Параметры.ПодборДляОплаты;
				Элементы.ПоказатьПроданные.Видимость = Не ПодборДляОплаты;
			КонецЕсли;
			
			                             
			Предприятие = Неопределено;
			Склад = Неопределено; 
			Если Параметры.Свойство("ЗаказКлиента") Тогда
				Если ЗначениеЗаполнено(Параметры.ЗаказКлиента) Тогда
					Предприятие = Параметры.ЗаказКлиента.Предприятие;
					Склад = Параметры.ЗаказКлиента.Склад;  
				КонецЕсли;
			КонецЕсли;
			
			Если Параметры.Свойство("Склад") Тогда
				Если ЗначениеЗаполнено(Параметры.Склад) Тогда
					Склад = Параметры.Склад;  
				КонецЕсли;
			КонецЕсли;
			
			Если Параметры.Свойство("Предприятие") Тогда
				Если ЗначениеЗаполнено(Параметры.Предприятие) Тогда
					Предприятие = Параметры.Предприятие;
				КонецЕсли;
			КонецЕсли;
			
			Если Параметры.Свойство("ДатаОтгрузки") И (Не Параметры.Свойство("ДокументСсылка") ИЛИ НЕ ЗначениеЗаполнено(Параметры.ДокументСсылка)) Тогда
				Если ЗначениеЗаполнено(Параметры.ДатаОтгрузки) Тогда
					Дата = КонецДня(Параметры.ДатаОтгрузки);
				КонецЕсли;
			КонецЕсли;
			МассивСубконто = Новый Массив;
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	УчетныйВидыСубконто.ВидСубконто КАК ВидСубконто,
			|	УчетныйВидыСубконто.ВидСубконто.ТипЗначения КАК ТипЗначения
			|ИЗ
			|	ПланСчетов.Учетный.ВидыСубконто КАК УчетныйВидыСубконто
			|ГДЕ
			|	УчетныйВидыСубконто.Ссылка = &Счет";
			Если ТипЗнч(Счет) = Тип("Массив") Тогда
				Запрос.УстановитьПараметр("Счет",Счет[0]);
			Иначе
				Запрос.УстановитьПараметр("Счет",Счет);
			КонецЕсли;
			РезультатЗапроса = Запрос.Выполнить();
			ВыборкаТипСубконто = РезультатЗапроса.Выбрать();
			МассивСубконто = Новый Массив;
			Пока ВыборкаТипСубконто.Следующий() Цикл
				Если ВыборкаТипСубконто.ТипЗначения.СодержитТип(Тип("СправочникСсылка.Номенклатура")) ИЛИ 
					ВыборкаТипСубконто.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ОсновныеСредства")) Тогда
					МассивСубконто.Вставить(0, ВыборкаТипСубконто.ВидСубконто);
				ИначеЕсли ВыборкаТипСубконто.ТипЗначения.СодержитТип(Тип("СправочникСсылка.Склады")) Тогда
					МассивСубконто.Вставить(1, ВыборкаТипСубконто.ВидСубконто);
				ИначеЕсли ВыборкаТипСубконто.ТипЗначения.СодержитТип(Тип("СправочникСсылка.СерииНоменклатуры")) Тогда
					МассивСубконто.Вставить(2, ВыборкаТипСубконто.ВидСубконто);
				КонецЕсли;
			КонецЦикла; 
			Список.Параметры.УстановитьЗначениеПараметра("ПоказатьПроданные", ПоказатьПроданные);
			Список.Параметры.УстановитьЗначениеПараметра("Дата", Дата);
			Список.Параметры.УстановитьЗначениеПараметра("Предприятие", Предприятие);
			Список.Параметры.УстановитьЗначениеПараметра("Склад", Склад);
			Список.Параметры.УстановитьЗначениеПараметра("Номенклатура", Номенклатура);
			Список.Параметры.УстановитьЗначениеПараметра("Счет", Счет);
			ПоказатьПроданные = Ложь;
			Элементы.Продан.Видимость = ПоказатьПроданные; 
		КонецЕсли;
	КонецЕсли;  
	
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПроданныеПриИзменении(Элемент)
	
	Элементы.Продан.Видимость = ПоказатьПроданные;
	Для Каждого ЭлементПараметр Из Список.Параметры.Элементы Цикл  
		Если ЭлементПараметр.Параметр = Новый ПараметрКомпоновкиДанных("ПоказатьПроданные") Тогда
			Список.Параметры.УстановитьЗначениеПараметра("ПоказатьПроданные", ПоказатьПроданные);
			Прервать;
		КонецЕсли;
	КонецЦикла;;
	
КонецПроцедуры

#КонецОбласти 

&НаСервере
Процедура ПолучитьМассивСчетов(МассивСчетов)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Учетный.Ссылка КАК Ссылка
	|ИЗ
	|	ПланСчетов.Учетный КАК Учетный
	|ГДЕ
	|	(Учетный.Код = ""41""
	|			ИЛИ Учетный.Код = ""43""
	|			ИЛИ Учетный.Ссылка В ИЕРАРХИИ
	|				(ВЫБРАТЬ
	|					Учетный.Ссылка КАК Ссылка
	|				ИЗ
	|					ПланСчетов.Учетный КАК Учетный
	|				ГДЕ
	|					Учетный.Код = ""10""))";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	УчетныйВидыСубконто.ВидСубконто КАК ВидСубконто,
		|	УчетныйВидыСубконто.ВидСубконто.ТипЗначения КАК ТипЗначения
		|ИЗ
		|	ПланСчетов.Учетный.ВидыСубконто КАК УчетныйВидыСубконто
		|ГДЕ
		|	УчетныйВидыСубконто.Ссылка = &Счет";
		Запрос.УстановитьПараметр("Счет",Выборка.Ссылка);
		РезультатЗапросаСубконто = Запрос.Выполнить();
		ВыборкаТипСубконто = РезультатЗапросаСубконто.Выбрать();
		МассивСубконто = Новый Массив;
		Пока ВыборкаТипСубконто.Следующий() Цикл
			Если ВыборкаТипСубконто.ТипЗначения.СодержитТип(Тип("СправочникСсылка.Номенклатура")) ИЛИ 
				ВыборкаТипСубконто.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ОсновныеСредства")) ИЛИ
				ВыборкаТипСубконто.ТипЗначения.СодержитТип(Тип("СправочникСсылка.Склады")) ИЛИ
				ВыборкаТипСубконто.ТипЗначения.СодержитТип(Тип("СправочникСсылка.СерииНоменклатуры")) Тогда
				МассивСубконто.Добавить(ВыборкаТипСубконто.ВидСубконто);
			КонецЕсли;
		КонецЦикла; 
		Если МассивСубконто.Количество() >= 3  Тогда
			МассивСчетов.Добавить(Выборка.Ссылка);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	Если ПараметрыФормы.Свойство("ДокументПодбора") Тогда
		Если ПараметрыФормы.ДокументПодбора = "УЧ_ВыпускПродукции" Тогда
			Если Элементы.Список.ТекущиеДанные.Количество < ПараметрыФормы.КоличествоПодбора Тогда
				Сообщить("Превышено выбираемое количество");
				СтандартнаяОбработка = Ложь;
			КонецЕсли;		
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры
