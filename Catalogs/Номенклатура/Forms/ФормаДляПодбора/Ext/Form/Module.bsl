﻿
&НаКлиенте
Процедура ПеренестиВДокумент(Команда) 
	
	АдресВХ = РаботаСВременнымХранилищем();
	Закрыть(АдресВХ);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка) 
	
	СтандартнаяОбработка = Ложь;
	Если Поле.Имя = "Счет10" Тогда
		СЗ = ПолучитьОстаткиВРазрезеСчетаНаСервере(Склад,Предприятие,ВыбраннаяСтрока);
		ПоказатьВыборИзМеню(Новый ОписаниеОповещения(),СЗ,Элемент);
	Иначе
		Если УказыватьКоличествоПриВыборе И УказыватьЦенуПриВыборе Тогда
			УказатьКоличество(Элемент.ТекущиеДанные.Ссылка,Истина);
		ИначеЕсли УказыватьКоличествоПриВыборе Тогда
			УказатьКоличество(Элемент.ТекущиеДанные.Ссылка,Ложь);
		ИначеЕсли УказыватьЦенуПриВыборе Тогда
			УказатьЦену(,Элемент.ТекущиеДанные.Ссылка);
		Иначе
			ДобавитьВыбранныеТовары(Элемент.ТекущиеДанные.Ссылка);
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
Процедура УказатьКоличество(Номенклатура, УказатьЦенуПослеКоличества)
	
	Количество = 0;
	ДопПараметры = Новый Структура("Номенклатура,УказатьЦенуПослеКоличества",Номенклатура,УказатьЦенуПослеКоличества);
	Оповещения = Новый ОписаниеОповещения("ВыборКоличества",ЭтотОбъект,ДопПараметры);
	ПоказатьВводЧисла(Оповещения, Количество, "Количество", 15, 3) 
	
КонецПроцедуры

&НаКлиенте
Процедура УказатьЦену(Количество = 1,Номенклатура)
	
	Цена = 0;
	ДопПараметры = Новый Структура("Номенклатура,Количество",Номенклатура,Количество);
	Оповещения = Новый ОписаниеОповещения("ВыборЦены",ЭтотОбъект,ДопПараметры);
	ПоказатьВводЧисла(Оповещения, Цена, "Цена", 15, 2) 
	
КонецПроцедуры


&НаКлиенте
Процедура ВыборКоличества(Количество,ДополнительныеПараметры) Экспорт
	
	Если Количество <> Неопределено Тогда
		Если ДополнительныеПараметры.УказатьЦенуПослеКоличества Тогда
			УказатьЦену(Количество,ДополнительныеПараметры.Номенклатура);
		Иначе
			ДобавитьВыбранныеТовары(ДополнительныеПараметры.Номенклатура,Количество);
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры 


&НаКлиенте
Процедура ДобавитьВыбранныеТовары(Номенклатура,Количество = 1, Цена = Неопределено)
	
	Если Цена <> Неопределено Тогда
		СтрокаПоиска = Новый Структура("Номенклатура,Цена",Номенклатура,Цена);
		МассивСтрок = ВыбранныеТовары.НайтиСтроки(СтрокаПоиска);
		Если МассивСтрок.Количество() > 0 Тогда 
			МассивСтрок[0].Количество = МассивСтрок[0].Количество + Количество; 
			РассчитатьСумму(МассивСтрок[0]);
		Иначе
			НоваяСтрока = ВыбранныеТовары.Добавить();
			НоваяСтрока.Номенклатура = Номенклатура;
			НоваяСтрока.Количество = Количество; 
			НоваяСтрока.Цена = Цена; 
			РассчитатьСумму(НоваяСтрока);
		КонецЕсли;
	Иначе
		СтрокаПоиска = Новый Структура("Номенклатура",Номенклатура);
		МассивСтрок = ВыбранныеТовары.НайтиСтроки(СтрокаПоиска);
		Если МассивСтрок.Количество() > 0 Тогда 
			МассивСтрок[0].Количество = МассивСтрок[0].Количество + Количество;
			РассчитатьСумму(МассивСтрок[0]);
		Иначе
			НоваяСтрока = ВыбранныеТовары.Добавить();
			НоваяСтрока.Номенклатура = Номенклатура;
			НоваяСтрока.Количество = Количество; 
			РассчитатьСумму(НоваяСтрока);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ВыборЦены(Цена,ДополнительныеПараметры) Экспорт
	
	Количество = ?(ДополнительныеПараметры.Свойство("Количество"),ДополнительныеПараметры.Количество,1);
	Если Цена <> Неопределено Тогда
		ДобавитьВыбранныеТовары(ДополнительныеПараметры.Номенклатура,Количество,Цена);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСумму(ТД)
	
	ТД.Сумма = ТД.Цена * ТД.Количество;
	
КонецПроцедуры


&НаСервере
Функция  РаботаСВременнымХранилищем()  
	
	ТЗВыбранныеТовары = ВыбранныеТовары.Выгрузить();
	АдресВХ = ПоместитьВоВременноеХранилище(ТЗВыбранныеТовары, Новый УникальныйИдентификатор);
	Возврат АдресВХ;   
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Склад") Тогда
		Склад = Параметры.Склад;
	КонецЕсли; 
	Если Параметры.Свойство("Предприятие") Тогда
		Предприятие = Параметры.Предприятие;
	КонецЕсли;
	Если Параметры.Свойство("Заголовок") Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;  
	Если Параметры.Свойство("Форма2") Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Форма2",Параметры.Форма2);
	Иначе
       Список.Параметры.УстановитьЗначениеПараметра("Форма2",Неопределено);
	КонецЕсли;

	Список.Параметры.УстановитьЗначениеПараметра("Родитель",Справочники.Номенклатура.ПустаяСсылка());
	Список.Параметры.УстановитьЗначениеПараметра("Склад",Склад);
	Список.Параметры.УстановитьЗначениеПараметра("Предприятие",Предприятие);
	Список.Параметры.УстановитьЗначениеПараметра("Счет41",ПланыСчетов.Учетный.Счет41()); 
	Список.Параметры.УстановитьЗначениеПараметра("Счет43",ПланыСчетов.Учетный.Счет43());
	Список.Параметры.УстановитьЗначениеПараметра("Счет10",ПланыСчетов.Учетный.Счет10());
	
	
КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент) 
	
	Список.Параметры.УстановитьЗначениеПараметра("Склад",Склад);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокГруппПриАктивизацииСтроки(Элемент)
	
	Список.Параметры.УстановитьЗначениеПараметра("Родитель",Элементы.СписокГрупп.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеТоварыКоличествоПриИзменении(Элемент)
	
	ТД = Элементы.ВыбранныеТовары.ТекущиеДанные;
	ТД.Сумма = ТД.Количество * ТД.Цена;
	
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


