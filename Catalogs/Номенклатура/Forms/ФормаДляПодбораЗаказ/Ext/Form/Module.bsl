﻿
&НаКлиенте
Процедура ПеренестиВДокумент(Команда) 
	
	АдресВХ = РаботаСВременнымХранилищем();
	Закрыть(АдресВХ);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка) 
	
	СтандартнаяОбработка = Ложь;
	СтруктураДополнительныхПараметровНоменклатуры = Новый Структура("Упаковка, Коэффициент, ЕдиницаИзмерения", Элемент.ТекущиеДанные.Упаковка, Элемент.ТекущиеДанные.Коэффициент, Элемент.ТекущиеДанные.ЕдиницаИзмерения);
	
	Если Поле.Имя = "Счет10" Тогда
		СЗ = ПолучитьОстаткиВРазрезеСчетаНаСервере(Склад,Предприятие,ВыбраннаяСтрока);
		ПоказатьВыборИзМеню(Новый ОписаниеОповещения(),СЗ,Элемент);
	Иначе
		
		Если УказыватьКоличествоПриВыборе И УказыватьЦенуПриВыборе Тогда
			УказатьКоличество(Элемент.ТекущиеДанные.Ссылка,Истина,, СтруктураДополнительныхПараметровНоменклатуры);
		ИначеЕсли УказыватьКоличествоПриВыборе Тогда
			УказатьКоличество(Элемент.ТекущиеДанные.Ссылка,Ложь,Элемент.ТекущиеДанные.ЦенаКлиента, СтруктураДополнительныхПараметровНоменклатуры);
		ИначеЕсли УказыватьЦенуПриВыборе Тогда
			УказатьЦену(,Элемент.ТекущиеДанные.Ссылка, СтруктураДополнительныхПараметровНоменклатуры);
		Иначе
			ДобавитьВыбранныеТовары(Элемент.ТекущиеДанные.Ссылка,,Элемент.ТекущиеДанные.ЦенаКлиента, СтруктураДополнительныхПараметровНоменклатуры);
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры 

&НаСервереБезКонтекста
Функция ПолучитьОстаткиВРазрезеСчетаНаСервере(Склад,Предприятие,Номенклатура)
    	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СУММА(УчетныйОстатки.КоличествоОстаток) КАК Остаток,
	|	УчетныйОстатки.Счет.Представление КАК Счет
	|ИЗ
	|	РегистрБухгалтерии.Учетный.Остатки КАК УчетныйОстатки
	|ГДЕ
	|	УчетныйОстатки.Счет.Родитель = &Родитель
	|	И ВЫБОР
	|			КОГДА &Предприятие = ЗНАЧЕНИЕ(Справочник.Предприятия.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ УчетныйОстатки.Предприятия = &Предприятие
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ УчетныйОстатки.Субконто2 = &Склад
	|		КОНЕЦ
	|	И УчетныйОстатки.Субконто1 = &Номенклатура
	|
	|СГРУППИРОВАТЬ ПО
	|	УчетныйОстатки.Счет.Представление";
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Предприятие", Предприятие);
	Запрос.УстановитьПараметр("Родитель", ПланыСчетов.Учетный.Счет10());
	Запрос.УстановитьПараметр("Склад", Склад);
	РезультатЗапроса = Запрос.Выполнить(); 
	Выборка = РезультатЗапроса.Выбрать(); 
	СЗ = Новый СписокЗначений;
	Пока Выборка.Следующий() Цикл
		СтрокаДляСЗ = "" + Формат(Выборка.Остаток,"ЧЦ=15; ЧДЦ=3; ЧН=0,000") + " (" + Выборка.Счет + ")";	
		СЗ.Добавить(СтрокаДляСЗ);	
	КонецЦикла; 
	Возврат СЗ;
	
КонецФункции

&НаКлиенте
Процедура УказатьКоличество(Номенклатура, УказатьЦенуПослеКоличества, Цена = Неопределено, СтруктураДополнительныхПараметровНоменклатуры)
	
	Количество = 0;
	ДопПараметры = Новый Структура("Номенклатура,УказатьЦенуПослеКоличества, Цена, СтруктураДополнительныхПараметровНоменклатуры",Номенклатура,УказатьЦенуПослеКоличества, Цена, СтруктураДополнительныхПараметровНоменклатуры);
	Оповещения = Новый ОписаниеОповещения("ВыборКоличества",ЭтотОбъект,ДопПараметры);
	ПоказатьВводЧисла(Оповещения, Количество, "Количество", 15, 3) 
	
КонецПроцедуры

&НаКлиенте
Процедура УказатьЦену(Количество = 1,Номенклатура, СтруктураДополнительныхПараметровНоменклатуры)
	
	Цена = 0;
	ДопПараметры = Новый Структура("Номенклатура,Количество, СтруктураДополнительныхПараметровНоменклатуры",Номенклатура,Количество, СтруктураДополнительныхПараметровНоменклатуры);
	Оповещения = Новый ОписаниеОповещения("ВыборЦены",ЭтотОбъект,ДопПараметры);
	ПоказатьВводЧисла(Оповещения, Цена, "Цена", 15, 2) 
	
КонецПроцедуры


&НаКлиенте
Процедура ВыборКоличества(Количество,ДополнительныеПараметры) Экспорт
	
	Если Количество <> Неопределено Тогда
		Если ДополнительныеПараметры.УказатьЦенуПослеКоличества Тогда
			УказатьЦену(Количество,ДополнительныеПараметры.Номенклатура, ДополнительныеПараметры.СтруктураДополнительныхПараметровНоменклатуры);
		Иначе
			ДобавитьВыбранныеТовары(ДополнительныеПараметры.Номенклатура,Количество,ДополнительныеПараметры.Цена, ДополнительныеПараметры.СтруктураДополнительныхПараметровНоменклатуры);
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры 


&НаКлиенте
Процедура ДобавитьВыбранныеТовары(Номенклатура,Количество = 1, Цена = Неопределено, СтруктураДополнительныхПараметровНоменклатуры)
	
	Если Цена <> Неопределено Тогда
		СтрокаПоиска = Новый Структура("Номенклатура,Цена",Номенклатура,Цена);
		МассивСтрок = ВыбранныеТовары.НайтиСтроки(СтрокаПоиска);
		
		Если МассивСтрок.Количество() > 0 Тогда 
			МассивСтрок[0].Количество = МассивСтрок[0].Количество + Количество; 
			РассчитатьЗависимыеДанныеСтроки(МассивСтрок[0], СтруктураДополнительныхПараметровНоменклатуры);
		Иначе
			НоваяСтрока = ВыбранныеТовары.Добавить();
			НоваяСтрока.Номенклатура = Номенклатура;
			НоваяСтрока.Количество = Количество; 
			НоваяСтрока.Цена = Цена; 
			РассчитатьЗависимыеДанныеСтроки(НоваяСтрока, СтруктураДополнительныхПараметровНоменклатуры);
		КонецЕсли;
		
	Иначе
		СтрокаПоиска = Новый Структура("Номенклатура",Номенклатура);
		МассивСтрок = ВыбранныеТовары.НайтиСтроки(СтрокаПоиска);
		
		Если МассивСтрок.Количество() > 0 Тогда 
			МассивСтрок[0].Количество = МассивСтрок[0].Количество + Количество;
			РассчитатьЗависимыеДанныеСтроки(МассивСтрок[0], СтруктураДополнительныхПараметровНоменклатуры);
		Иначе
			НоваяСтрока = ВыбранныеТовары.Добавить();
			НоваяСтрока.Номенклатура = Номенклатура;
			НоваяСтрока.Количество = Количество; 
			РассчитатьЗависимыеДанныеСтроки(НоваяСтрока, СтруктураДополнительныхПараметровНоменклатуры);
		КонецЕсли;  
		
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ВыборЦены(Цена,ДополнительныеПараметры) Экспорт
	
	Количество = ?(ДополнительныеПараметры.Свойство("Количество"),ДополнительныеПараметры.Количество,1);
	
	Если Цена <> Неопределено Тогда
		ДобавитьВыбранныеТовары(ДополнительныеПараметры.Номенклатура,Количество,Цена, ДополнительныеПараметры.СтруктураДополнительныхПараметровНоменклатуры);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьЗависимыеДанныеСтроки(ТД, СтруктураДополнительныхПараметровНоменклатуры)
	
	ТД.Сумма = ТД.Цена * ТД.Количество;  
	
	Упаковка = ?(ЗначениеЗаполнено(СтруктураДополнительныхПараметровНоменклатуры.Упаковка), СтруктураДополнительныхПараметровНоменклатуры.Упаковка, "уп.");
	
	Если СтруктураДополнительныхПараметровНоменклатуры.Коэффициент = 0 ИЛИ СтруктураДополнительныхПараметровНоменклатуры.Коэффициент = 1 Тогда
		КолУпаковок = СтруктураДополнительныхПараметровНоменклатуры.Коэффициент;
		КолЕдиниц = ТД.Количество; 
	Иначе
		КолУпаковок = Цел(ТД.Количество / СтруктураДополнительныхПараметровНоменклатуры.Коэффициент);
		КолЕдиниц = ТД.Количество - (КолУпаковок * СтруктураДополнительныхПараметровНоменклатуры.Коэффициент);
	КонецЕсли;
	
	ТД.КоличествоУпаковокПредставление = "" + КолУпаковок + " " + Упаковка + ?(КолЕдиниц, ", " + КолЕдиниц + " " + СтруктураДополнительныхПараметровНоменклатуры.ЕдиницаИзмерения, "");
    ТД.Упаковка = СтруктураДополнительныхПараметровНоменклатуры.Упаковка;
	ТД.Коэффициент = СтруктураДополнительныхПараметровНоменклатуры.Коэффициент;
	ТД.ЕдиницаИзмерения = СтруктураДополнительныхПараметровНоменклатуры.ЕдиницаИзмерения; 
	
	Если ЗначениеЗаполнено(ТД.ЕдиницаИзмерения) И ЗначениеЗаполнено(ТД.Коэффициент) Тогда
		ТД.КоличествоВУпаковкеПредставление = "(" +  Строка(ТД.Коэффициент) + " " + Строка(ТД.ЕдиницаИзмерения) +")";
	ИначеЕсли ЗначениеЗаполнено(ТД.Коэффициент) Тогда
		ТД.КоличествоВУпаковкеПредставление = Строка(ТД.Коэффициент);
	Иначе
		ТД.КоличествоВУпаковкеПредставление = ТД.КоличествоУпаковокПредставление;
	КонецЕсли;
		
КонецПроцедуры


&НаСервере
Функция  РаботаСВременнымХранилищем()  
	
	ТЗВыбранныеТовары = ВыбранныеТовары.Выгрузить();
	АдресВХ = ПоместитьВоВременноеХранилище(ТЗВыбранныеТовары, Новый УникальныйИдентификатор);
	Возврат АдресВХ;   
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Контрагент") Тогда
		Контрагент = Параметры.Контрагент;
	КонецЕсли; 
	
	Если Параметры.Свойство("Договор") Тогда
		Договор = Параметры.Договор;
	КонецЕсли; 
	
	Если Параметры.Свойство("Склад") Тогда
		Склад = Параметры.Склад;
	КонецЕсли; 
	
	Если Параметры.Свойство("Предприятие") Тогда
		Предприятие = Параметры.Предприятие;
	КонецЕсли;
	
	Если Параметры.Свойство("Заголовок") Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;  
	
	ПериодИсторииЗаказов.ДатаНачала = НачалоМесяца(ТекущаяДата());
	ПериодИсторииЗаказов.ДатаОкончания = КонецМесяца(ТекущаяДата());
	
	Список.ТекстЗапроса = ТекстЗапросаПодбораВЗаказе();
	
	Если Параметры.Свойство("Форма2") Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Форма2",Параметры.Форма2);
	Иначе
       Список.Параметры.УстановитьЗначениеПараметра("Форма2",Неопределено);
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("Склад",Склад);
	Список.Параметры.УстановитьЗначениеПараметра("Предприятие",Предприятие); 
	Список.Параметры.УстановитьЗначениеПараметра("Счет10",ПланыСчетов.Учетный.Счет10());
	Список.Параметры.УстановитьЗначениеПараметра("Счет41",ПланыСчетов.Учетный.Счет41()); 
	Список.Параметры.УстановитьЗначениеПараметра("Счет43",ПланыСчетов.Учетный.Счет43()); 
	Список.Параметры.УстановитьЗначениеПараметра("Родитель",Справочники.Номенклатура.ПустаяСсылка());
	Список.Параметры.УстановитьЗначениеПараметра("Контрагент", Контрагент);
	Список.Параметры.УстановитьЗначениеПараметра("НачалоПериодаИсторииЗаказов", ?(ЗначениеЗаполнено(ПериодИсторииЗаказов.ДатаНачала), ПериодИсторииЗаказов.ДатаНачала, НачалоМесяца(ТекущаяДата())));
	Список.Параметры.УстановитьЗначениеПараметра("КонецПериодаИсторииЗаказов", ?(ЗначениеЗаполнено(ПериодИсторииЗаказов.ДатаОкончания), ПериодИсторииЗаказов.ДатаОкончания, КонецМесяца(ТекущаяДата())));
	Список.Параметры.УстановитьЗначениеПараметра("НоменклатураПоИсторииЗаказов", НоменклатураПоИсторииЗаказов);
	Список.Параметры.УстановитьЗначениеПараметра("ТицЦенКонтрагента", ?(ЗначениеЗаполнено(Договор), ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор, "ТипЦен"), Справочники.ТипыЦенНоменклатуры.ПустаяСсылка()));
	Список.Параметры.УстановитьЗначениеПараметра("Тиц1ЦенаКП", Справочники.ТипыЦенНоменклатуры.НайтиПоНаименованию("1. Цена КП (-)", Истина));
	Список.Параметры.УстановитьЗначениеПараметра("Тиц2ЦенаКП", Справочники.ТипыЦенНоменклатуры.НайтиПоНаименованию("2. Цена КП (+)", Истина));
	Список.Параметры.УстановитьЗначениеПараметра("Тиц3ЦенаОК", Справочники.ТипыЦенНоменклатуры.НайтиПоНаименованию("3. Цена ОК (-)", Истина));
	Список.Параметры.УстановитьЗначениеПараметра("Тиц4ЦенаОК", Справочники.ТипыЦенНоменклатуры.НайтиПоНаименованию("4. Цена ОК (+)", Истина));
	Список.Параметры.УстановитьЗначениеПараметра("Тиц5ЦенаКК", Справочники.ТипыЦенНоменклатуры.НайтиПоНаименованию("5. Цена КК (-)", Истина));
	Список.Параметры.УстановитьЗначениеПараметра("Тиц6ЦенаКК", Справочники.ТипыЦенНоменклатуры.НайтиПоНаименованию("6. Цена КК (+)", Истина));
	Список.Параметры.УстановитьЗначениеПараметра("Тиц7ЦенаСК", Справочники.ТипыЦенНоменклатуры.НайтиПоНаименованию("7. Цена СК", Истина));  
	Список.Параметры.УстановитьЗначениеПараметра("Тиц8ЦенаРК", Справочники.ТипыЦенНоменклатуры.НайтиПоНаименованию("8. Цена РК", Истина));
	
	СписокОстаткиПоСериям.Параметры.УстановитьЗначениеПараметра("Склад",Склад);
	СписокОстаткиПоСериям.Параметры.УстановитьЗначениеПараметра("Предприятие",Предприятие);             
	СписокОстаткиПоСериям.Параметры.УстановитьЗначениеПараметра("Счет10",ПланыСчетов.Учетный.Счет10());
	СписокОстаткиПоСериям.Параметры.УстановитьЗначениеПараметра("Счет41",ПланыСчетов.Учетный.Счет41()); 
	СписокОстаткиПоСериям.Параметры.УстановитьЗначениеПараметра("Счет43",ПланыСчетов.Учетный.Счет43());  
	СписокОстаткиПоСериям.Параметры.УстановитьЗначениеПараметра("Номенклатура", Справочники.Номенклатура.ПустаяСсылка());
	
КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент) 
	
	СписокОстаткиПоСериям.Параметры.УстановитьЗначениеПараметра("Склад",Склад);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	СписокОстаткиПоСериям.Параметры.УстановитьЗначениеПараметра("Номенклатура",Элементы.Список.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокГруппПриАктивизацииСтроки(Элемент)
	
	Список.Параметры.УстановитьЗначениеПараметра("Родитель",Элементы.СписокГрупп.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеТоварыКоличествоПриИзменении(Элемент)
	
	ТД = Элементы.ВыбранныеТовары.ТекущиеДанные;
	ТД.Сумма = ТД.Количество * ТД.Цена;
	
	Упаковка = ?(ЗначениеЗаполнено(ТД.Упаковка), ТД.Упаковка, "уп.");
	
	Если ТД.Коэффициент = 0 ИЛИ ТД.Коэффициент = 1 Тогда
		КолУпаковок = ТД.Коэффициент;
		КолЕдиниц = ТД.Количество; 
	Иначе
		КолУпаковок = Цел(ТД.Количество / ТД.Коэффициент);
		КолЕдиниц = ТД.Количество - (КолУпаковок * ТД.Коэффициент);
	КонецЕсли;
	
	ТД.КоличествоУпаковокПредставление = "" + КолУпаковок + " " + Упаковка + ?(КолЕдиниц, ", " + КолЕдиниц + " " + ТД.ЕдиницаИзмерения, "");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеТоварыЦенаПриИзменении(Элемент)
	
	ТД = Элементы.ВыбранныеТовары.ТекущиеДанные;
	ТД.Сумма = ТД.Количество * ТД.Цена;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеТоварыСуммаПриИзменении(Элемент)
	
	ТД = Элементы.ВыбранныеТовары.ТекущиеДанные;
	ТД.Цена = ?(ТД.Количество = 0,0,ТД.Сумма / ТД.Количество);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТекстЗапросаПодбораВЗаказе()
    	
	Возврат "ВЫБРАТЬ
	        |	СправочникНоменклатура.Ссылка КАК Ссылка,
	        |	СправочникНоменклатура.ПометкаУдаления КАК ПометкаУдаления,
	        |	СправочникНоменклатура.Код КАК Код,
	        |	СправочникНоменклатура.Наименование КАК Наименование,
	        |	СправочникНоменклатура.Предопределенный КАК Предопределенный,
	        |	СправочникНоменклатура.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных,
	        |	МАКСИМУМ(ВЫБОР
	        |			КОГДА ЦеныНоменклатурыСрезПоследних.ТипЦен = &ТицЦенКонтрагента
	        |				ТОГДА ЦеныНоменклатурыСрезПоследних.Цена
	        |			ИНАЧЕ 0
	        |		КОНЕЦ) КАК ЦенаКлиента,
	        |	МАКСИМУМ(ВЫБОР
	        |			КОГДА ЦеныНоменклатурыСрезПоследних.ТипЦен = &Тиц1ЦенаКП
	        |				ТОГДА ЦеныНоменклатурыСрезПоследних.Цена
	        |			ИНАЧЕ 0
	        |		КОНЕЦ) КАК Цена1КП,
	        |	МАКСИМУМ(ВЫБОР
	        |			КОГДА ЦеныНоменклатурыСрезПоследних.ТипЦен = &Тиц2ЦенаКП
	        |				ТОГДА ЦеныНоменклатурыСрезПоследних.Цена
	        |			ИНАЧЕ 0
	        |		КОНЕЦ) КАК Цена2КП,
	        |	МАКСИМУМ(ВЫБОР
	        |			КОГДА ЦеныНоменклатурыСрезПоследних.ТипЦен = &Тиц3ЦенаОК
	        |				ТОГДА ЦеныНоменклатурыСрезПоследних.Цена
	        |			ИНАЧЕ 0
	        |		КОНЕЦ) КАК Цена3ОК,
	        |	МАКСИМУМ(ВЫБОР
	        |			КОГДА ЦеныНоменклатурыСрезПоследних.ТипЦен = &Тиц4ЦенаОК
	        |				ТОГДА ЦеныНоменклатурыСрезПоследних.Цена
	        |			ИНАЧЕ 0
	        |		КОНЕЦ) КАК Цена4ОК,
	        |	МАКСИМУМ(ВЫБОР
	        |			КОГДА ЦеныНоменклатурыСрезПоследних.ТипЦен = &Тиц5ЦенаКК
	        |				ТОГДА ЦеныНоменклатурыСрезПоследних.Цена
	        |			ИНАЧЕ 0
	        |		КОНЕЦ) КАК Цена5КК,
	        |	МАКСИМУМ(ВЫБОР
	        |			КОГДА ЦеныНоменклатурыСрезПоследних.ТипЦен = &Тиц6ЦенаКК
	        |				ТОГДА ЦеныНоменклатурыСрезПоследних.Цена
	        |			ИНАЧЕ 0
	        |		КОНЕЦ) КАК Цена6КК,
	        |	МАКСИМУМ(ВЫБОР
	        |			КОГДА ЦеныНоменклатурыСрезПоследних.ТипЦен = &Тиц7ЦенаСК
	        |				ТОГДА ЦеныНоменклатурыСрезПоследних.Цена
	        |			ИНАЧЕ 0
	        |		КОНЕЦ) КАК Цена7СК,
	        |	МАКСИМУМ(ВЫБОР
	        |			КОГДА ЦеныНоменклатурыСрезПоследних.ТипЦен = &Тиц8ЦенаРК
	        |				ТОГДА ЦеныНоменклатурыСрезПоследних.Цена
	        |			ИНАЧЕ 0
	        |		КОНЕЦ) КАК Цена8РК,
	        |	СУММА(ЕСТЬNULL(УчетныйОстатки.КоличествоОстаток, 0)) КАК Остаток,
	        |	УпаковкиНоменклатуры.Упаковка КАК Упаковка,
	        |	МАКСИМУМ(УпаковкиНоменклатуры.Коэффициент) КАК Коэффициент,
	        |	СправочникНоменклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения
	        |ИЗ
	        |	Справочник.Номенклатура КАК СправочникНоменклатура
	        |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних КАК ЦеныНоменклатурыСрезПоследних
	        |		ПО СправочникНоменклатура.Ссылка = ЦеныНоменклатурыСрезПоследних.Номенклатура
	        |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Учетный.Остатки(
	        |				,
	        |				Счет = &Счет41
	        |					ИЛИ Счет = &Счет43
	        |					ИЛИ Счет.Родитель = &Счет10
	        |					ИЛИ Счет = &Счет10,
	        |				,
	        |				ВЫБОР
	        |						КОГДА &Предприятие = ЗНАЧЕНИЕ(Справочник.Предприятия.ПустаяСсылка)
	        |							ТОГДА ИСТИНА
	        |						ИНАЧЕ Предприятия = &Предприятие
	        |					КОНЕЦ
	        |					И ВЫБОР
	        |						КОГДА &Родитель = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	        |							ТОГДА ИСТИНА
	        |						ИНАЧЕ Субконто1 В ИЕРАРХИИ (&Родитель)
	        |					КОНЕЦ
	        |					И ВЫБОР
	        |						КОГДА &Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	        |							ТОГДА ИСТИНА
	        |						ИНАЧЕ Субконто2 = &Склад
	        |					КОНЕЦ) КАК УчетныйОстатки
	        |		ПО (СправочникНоменклатура.Ссылка = (ВЫРАЗИТЬ(УчетныйОстатки.Субконто1 КАК Справочник.Номенклатура)))
	        |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УпаковкиНоменклатуры КАК УпаковкиНоменклатуры
	        |		ПО СправочникНоменклатура.Ссылка = УпаковкиНоменклатуры.Номенклатура
	        |			И СправочникНоменклатура.ЕдиницаИзмерения = УпаковкиНоменклатуры.ЕдиницаИзмерения
	        |ГДЕ
	        |	НЕ СправочникНоменклатура.ЭтоГруппа
	        |	И НЕ СправочникНоменклатура.ПометкаУдаления
	        |	И ВЫБОР
	        |			КОГДА &Родитель = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	        |				ТОГДА ИСТИНА
	        |			ИНАЧЕ СправочникНоменклатура.Ссылка В ИЕРАРХИИ (&Родитель)
	        |		КОНЕЦ
	        |	И ВЫБОР
	        |			КОГДА &Форма2 = НЕОПРЕДЕЛЕНО
	        |				ТОГДА ИСТИНА
	        |			ИНАЧЕ СправочникНоменклатура.Форма2 = &Форма2
	        |		КОНЕЦ
	        |	И ВЫБОР
	        |			КОГДА &НоменклатураПоИсторииЗаказов
	        |					И &Контрагент <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	        |				ТОГДА СправочникНоменклатура.Ссылка В
	        |						(ВЫБРАТЬ РАЗЛИЧНЫЕ
	        |							ЗаказКлиентаТабличнаяЧасть.Номенклатура КАК Номенклатура
	        |						ИЗ
	        |							Документ.ЗаказКлиента.ТабличнаяЧасть КАК ЗаказКлиентаТабличнаяЧасть
	        |						ГДЕ
	        |							ЗаказКлиентаТабличнаяЧасть.Ссылка.Контрагент = &Контрагент
	        |							И ЗаказКлиентаТабличнаяЧасть.Ссылка.ПометкаУдаления = ЛОЖЬ
	        |							И ЗаказКлиентаТабличнаяЧасть.Ссылка.Дата МЕЖДУ &НачалоПериодаИсторииЗаказов И &КонецПериодаИсторииЗаказов)
	        |			ИНАЧЕ ИСТИНА
	        |		КОНЕЦ
	        |
	        |СГРУППИРОВАТЬ ПО
	        |	СправочникНоменклатура.Ссылка,
	        |	СправочникНоменклатура.ПометкаУдаления,
	        |	СправочникНоменклатура.Код,
	        |	СправочникНоменклатура.Наименование,
	        |	СправочникНоменклатура.Предопределенный,
	        |	СправочникНоменклатура.ИмяПредопределенныхДанных,
	        |	УпаковкиНоменклатуры.Упаковка,
	        |	СправочникНоменклатура.ЕдиницаИзмерения";
	
КонецФункции

&НаКлиенте
Процедура НоменклатураПоИсторииЗаказовПриИзменении(Элемент)
	
	Список.Параметры.УстановитьЗначениеПараметра("НоменклатураПоИсторииЗаказов", НоменклатураПоИсторииЗаказов);
	
КонецПроцедуры  

&НаКлиенте
Процедура ПериодИсторииЗаказовПриИзменении(Элемент)
	
	Список.Параметры.УстановитьЗначениеПараметра("НачалоПериодаИсторииЗаказов", ?(ЗначениеЗаполнено(ПериодИсторииЗаказов.ДатаНачала), ПериодИсторииЗаказов.ДатаНачала, НачалоМесяца(ТекущаяДата())));
	Список.Параметры.УстановитьЗначениеПараметра("КонецПериодаИсторииЗаказов", ?(ЗначениеЗаполнено(ПериодИсторииЗаказов.ДатаОкончания), ПериодИсторииЗаказов.ДатаОкончания, КонецМесяца(ТекущаяДата())));

КонецПроцедуры


