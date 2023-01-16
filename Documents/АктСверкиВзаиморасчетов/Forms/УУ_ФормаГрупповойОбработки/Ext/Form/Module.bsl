﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОсновнаяОрганизация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
		
	Справочники.Организации.ПроверитьНаличиеОрганизацииПриОднофирменномУчете(ОсновнаяОрганизация);
		
	Организация = ОсновнаяОрганизация;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВыбратьПериод(Команда)  
	
	ПараметрыФормы = Новый Структура("НачалоПериода, КонецПериода", ДатаНачала, ДатаОкончания);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыФормы, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);   
	
КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокКонтрагентПриИзменении(Элемент)
	
	Элементы.Список.ТекущиеДанные.ЭДО = ПодключенЭДО(Элементы.Список.ТекущиеДанные.Контрагент);
	Если НЕ Элементы.Список.ТекущиеДанные.ЭДО Тогда
		Элементы.Список.ТекущиеДанные.Почта = ЕстьEmail(Элементы.Список.ТекущиеДанные.Контрагент);
		Если НЕ Элементы.Список.ТекущиеДанные.Почта Тогда
			Элементы.Список.ТекущиеДанные.Печать = Истина;  
		Иначе
			Элементы.Список.ТекущиеДанные.Печать = Ложь;
		КонецЕсли;  
	Иначе
		Элементы.Список.ТекущиеДанные.Почта = Ложь;
		Элементы.Список.ТекущиеДанные.Печать = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СписокОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка) 
	
	Для каждого ВыбранныйКонтрагент Из ВыбранноеЗначение Цикл
		НоваяСтрока = Список.Добавить();
		НоваяСтрока.Контрагент = ВыбранныйКонтрагент; 
		НоваяСтрока.ЭДО = ПодключенЭДО(НоваяСтрока.Контрагент);
		Если НЕ НоваяСтрока.ЭДО Тогда
			НоваяСтрока.Почта = ЕстьEmail(НоваяСтрока.Контрагент);
			Если НЕ НоваяСтрока.Почта Тогда
				НоваяСтрока.Печать = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура СписокЭДОПриИзменении(Элемент)
	
	Если Элементы.Список.ТекущиеДанные.ЭДО Тогда  
		//Если поднят флажок, проверим техническую возможность
		Элементы.Список.ТекущиеДанные.ЭДО = ПодключенЭДО(Элементы.Список.ТекущиеДанные.Контрагент);
	КонецЕсли;	
		
КонецПроцедуры   

&НаКлиенте
Процедура СписокПечатьПриИзменении(Элемент)
	
	Если Элементы.Список.ТекущиеДанные.Печать Тогда  
		//Если поднят флажок, проверим техническую возможность
		Элементы.Список.ТекущиеДанные.Печать = ЕстьEmail(Элементы.Список.ТекущиеДанные.Контрагент);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подобрать(Команда)
	
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора",Истина);
	ПараметрыФормы.Вставить("МножественныйВыбор",Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",ложь);
    ОткрытьФорму("Справочник.Контрагенты.ФормаВыбора", ПараметрыФормы, Элементы.Список);  
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьАктыСверок(Команда)  
	
	Для каждого стр из список Цикл   
		
		НовыйДокумент = СоздатьАктСверокиНаСервере(Стр.Контрагент); 

		Форма = ПолучитьФорму("Документ.АктСверкиВзаиморасчетов.Форма.ФормаДокумента", Новый Структура("Ключ", НовыйДокумент));
	    Форма.УУ_ЗаполнитьДаннымиБухгалтерскогоУчета();  
		Форма.Записать();
		
		Стр.АктСверки = НовыйДокумент;
		
	КонецЦикла 
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоПочте(Команда)  
	ОтправитьПоПочтеНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	ТабДок = ПечатьНаСервере();
	
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.АвтоМасштаб = Истина;
		
	ФормаПечати = ПолучитьФорму("ОбщаяФорма.ФормаПечатиДокумента");//,,,КлючУникальности);
	ФормаПечати.Результат = ТабДок;
	ФормаПечати.Открыть(); 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиОписанияОповещения

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ДатаНачала    = РезультатВыбора.НачалоПериода;
	ДатаОкончания = РезультатВыбора.КонецПериода;
		
КонецПроцедуры

#КонецОбласти

&НаСервере
Функция СоздатьАктСверокиНаСервере(Контрагент)
	
		НовыйДокумент = Документы.АктСверкиВзаиморасчетов.СоздатьДокумент(); 
		ЗаполнениеДокументов.Заполнить(НовыйДокумент);
		Новыйдокумент.Организация = Организация;
		НовыйДокумент.Контрагент = Контрагент;
		Новыйдокумент.ДатаНачала = ДатаНачала;
		Новыйдокумент.ДатаОкончания = ДатаОкончания; 
		// Заполняем счета учета взаиморасчетов
		ТаблицаСчетов = УчетВзаиморасчетов.ПолучитьТаблицуСчетовУчетаВзаиморасчетов(Истина, Ложь);
		ТаблицаСчетов.Колонки.СчетРасчетов.Имя = "Счет";
		ТаблицаСчетов.Колонки.Добавить("УчаствуетВРасчетах", Новый ОписаниеТипов("Булево"));
		ТаблицаСчетов.ЗаполнитьЗначения(Истина, "УчаствуетВРасчетах");
		Новыйдокумент.СписокСчетов.Загрузить(ТаблицаСчетов);
		
		Если ЗначениеЗаполнено(НовыйДокумент.Контрагент) Тогда
			НовыйДокумент.ПредставительКонтрагента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НовыйДокумент.Контрагент, "ОсновноеКонтактноеЛицо");
		КонецЕсли;
		Если ЗначениеЗаполнено(НовыйДокумент.Организация) Тогда
			НовыйДокумент.ПредставительОрганизации = Документы.АктСверкиВзаиморасчетов.ПредставительОрганизации(НовыйДокумент.Организация, НовыйДокумент.Дата);
		КонецЕсли;    
		НовыйДокумент.Записать(); 
		
		Возврат НовыйДокумент.Ссылка; 
	
КонецФункции    

Функция ПодключенЭДО(Контрагент);  
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА СостоянияКонтрагентовБЭД.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияКонтрагентаБЭД.НастроенЭДО)
	|			ТОГДА Истина
	|		ИНАЧЕ Ложь
	|	КОНЕЦ КАК Состояние
	|ИЗ
	|	РегистрСведений.СостоянияКонтрагентовБЭД КАК СостоянияКонтрагентовБЭД
	|ГДЕ
	|	СостоянияКонтрагентовБЭД.Контрагент = &Контрагент";
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Состояние;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции 

Функция ЕстьEmail(Контрагент)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		МодульУправлениеКонтактнойИнформацией = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформацией");
		Адрес = МодульУправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(
		Контрагент, МодульУправлениеКонтактнойИнформацией.ВидКонтактнойИнформацииПоИмени("EmailКонтрагенты"));
	Иначе  
		Адрес = "";
	КонецЕсли;
	
	Если ПустаяСтрока(Адрес) Тогда
		Возврат Ложь
	Иначе
		Возврат Истина
	КонецЕсли;
	
КонецФункции	

&НаСервере
Процедура ОтправитьПоПочтеНаСервере()  
	
	ДоступныеУчетныеЗаписи = РаботаСПочтовымиСообщениями.ДоступныеУчетныеЗаписи(Истина);
	Если ДоступныеУчетныеЗаписи.Количество() = 0 Тогда
		Ошибка = НСтр("ru = 'Не обнаружены доступные учетные записи электронной почты'");
		ЗаписьЖурналаРегистрации("ОшикбаОтправкиУведомлений", УровеньЖурналаРегистрации.Ошибка,,,Ошибка);;
	Иначе
	    УчетнаяЗапись = ДоступныеУчетныеЗаписи[0].Ссылка; 

		СписокПисем = ПодготовитьПисьма();   
		ПисьмаКОтправке = Новый Массив;
		Для каждого Письмо из СписокПисем Цикл 
			ПараметрыПисьма = СформироватьПараметрыПисьма(Письмо);
			ПисьмаКОтправке.Добавить(РаботаСПочтовымиСообщениями.ПодготовитьПисьмо(УчетнаяЗапись, ПараметрыПисьма));   
		КонецЦикла;
		РезультатОтправки = РаботаСПочтовымиСообщениями.ОтправитьПисьма(УчетнаяЗапись, ПисьмаКОтправке);
	КонецЕсли;
	

КонецПроцедуры   

&НаСервере
Функция ПодготовитьПисьма() 
	
	СписокПисем = Новый Массив;
	
	Для каждого Стр из Список Цикл 
		Если Не Стр.Почта Тогда   
			Продолжить
		КонецЕсли;
		
		МассивВложений = Новый Массив;   
	
		МассивОбъектов = Новый Массив;
		МассивОбъектов.Добавить(Стр.АктСверки);
		ПараметрыПечати = Новый Структура;
		КоллекцияПечатныхФорм = УправлениеПечатью.ПодготовитьКоллекциюПечатныхФорм("АктСверки"); 
		ОбъектыПечати = Новый СписокЗначений;
		ПараметрыВывода = Новый Структура;
		
		Документы.АктСверкиВзаиморасчетов.Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхформ, ОбъектыПечати, ПараметрыВывода);  
		
		ТабДок = КоллекцияПечатныхФорм[0].ТабличныйДокумент;
		
		Вложение = Новый Структура;
		Вложение.Вставить("АдресВоВременномХранилище", ПоместитьВоВременноеХранилище(ТабДок, Новый УникальныйИдентификатор));  
		НомерНаПечать = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Стр.АктСверки.Номер, Истина, Ложь);
		Вложение.Вставить("Представление", "Акт сверки взаиморасчетов №"+НомерНаПечать+" от "+Формат(Стр.АктСверки.Дата,"ДЛФ=DD")); 
		Вложение.Вставить("Формат", "PDF_A_3");  
		МассивВложений.Добавить(Вложение);  
		
		МодульУправлениеКонтактнойИнформацией = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформацией");
		Адрес = МодульУправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(
		Стр.Контрагент, МодульУправлениеКонтактнойИнформацией.ВидКонтактнойИнформацииПоИмени("EmailКонтрагенты"));
		
		СтруктураПисьма = Новый Структура;   
		СтруктураПисьма.Вставить("ПолучательКонтрагент", Стр.Контрагент);
		СтруктураПисьма.Вставить("Получатель", Адрес);
		СтруктураПисьма.Вставить("Вложения", МассивВложений); 
		
		СписокПисем.Добавить(СтруктураПисьма);
		
	КонецЦикла;
	
	Возврат СписокПисем
	
КонецФункции

&НаСервере
Функция СформироватьПараметрыПисьма(Сообщение) 
	
	ПараметрыПисьма = Новый Структура;
	
	Кому = Новый Массив;  
	
	ПочтаПолучателей = ОбщегоНазначенияКлиентСервер.АдресаЭлектроннойПочтыИзСтроки(Сообщение.Получатель);
	Для каждого ПочтаПолучателя Из ПочтаПолучателей Цикл
		Кому.Добавить(Новый Структура("Адрес, Представление", ПочтаПолучателя.Адрес, ПочтаПолучателя.Псевдоним));
	КонецЦикла;
	
	Если Кому.Количество() > 0 Тогда
		ПараметрыПисьма.Вставить("Кому", Кому);
	КонецЕсли;     
	
	ПараметрыПисьма.Вставить("Тема", "Документы для "+Сообщение.ПолучательКонтрагент.НаименованиеПолное+" от "+Организация.НаименованиеСокращенное);
	
	ТелоПисьма = "К письму приложены документы для "+Сообщение.ПолучательКонтрагент.НаименованиеПолное+" от "+Организация.НаименованиеСокращенное;
	
	МассивВложений = Сообщение.Вложения;
	ГотовыйМассивВложений = Новый Массив;
	Для Ид = 0 по МассивВложений.Количество()-1 Цикл
		ТелоПисьма = ТелоПисьма + Символы.ПС+"- "+МассивВложений[Ид].Представление;
		ФорматыСохранения = Новый Массив;
		ФорматыСохранения.Добавить(МассивВложений[Ид].Формат);
		
		НастройкиСохранения = Новый Структура;
		НастройкиСохранения.Вставить("УпаковатьВАрхив", Ложь);
		НастройкиСохранения.Вставить("ФорматыСохранения", ФорматыСохранения);
		НастройкиСохранения.Вставить("ПереводитьИменаФайловВТранслит", Ложь);
		
		Вложение = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(МассивВложений[Ид]);
		РаботаСПочтовымиСообщениямиВызовСервера.ПодготовитьВложения(Вложение, НастройкиСохранения);
		ГотовыйМассивВложений.Добавить(Вложение[0]);
	КонецЦикла;	    
	
	ПараметрыПисьма.Вставить("Тело", ТелоПисьма);
	ПараметрыПисьма.Вставить("Вложения", ГотовыйМассивВложений);
	
	Возврат ПараметрыПисьма;
	
КонецФункции  

&НаСервере
Функция ПечатьНаСервере()  
	
	МассивОбъектов = Новый Массив;
	ПараметрыПечати = Новый Структура;
	КоллекцияПечатныхФорм = УправлениеПечатью.ПодготовитьКоллекциюПечатныхФорм("АктСверки"); 
	ОбъектыПечати = Новый СписокЗначений;
	ПараметрыВывода = Новый Структура;
    
	Для каждого Стр из Список Цикл 
		Если Не Стр.Печать Тогда   
			Продолжить
		КонецЕсли;
		
		МассивОбъектов.Добавить(Стр.АктСверки);
    КонецЦикла;
	
	Документы.АктСверкиВзаиморасчетов.Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхформ, ОбъектыПечати, ПараметрыВывода);  
		
	Возврат КоллекцияПечатныхФорм[0].ТабличныйДокумент;  
	
КонецФункции

#КонецОбласти



