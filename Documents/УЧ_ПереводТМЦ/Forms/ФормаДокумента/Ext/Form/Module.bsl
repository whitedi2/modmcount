﻿&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
	//	МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
	//	МодульУправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	//КонецЕсли;
	
	//++саб
	сабПриЧтенииНаСервере(ТекущийОбъект);
	//--саб
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
	//	МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
	//	МодульУправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, Новый Структура("ИмяЭлементаДляРазмещения", "СтраницаДополнительныеРеквизиты") );
	//КонецЕсли;
	
	//++саб
	сабПриСозданииНаСервере(Отказ, СтандартнаяОбработка);
	//--саб
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
	//	МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
	//	МодульУправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	//КонецЕсли;
	
	//++саб
	сабПриОткрытии(Отказ);
	//--саб
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	//Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
	//	МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
	//	
	//	Если МодульУправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
	//		ОбновитьЭлементыДополнительныхРеквизитов();
	//		МодульУправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	//	КонецЕсли;
	//	
	//КонецЕсли;
	
	Если ИмяСобытия = "Запись_Файл" Тогда
		Если Параметр.Свойство("ФормаВладелецУИД") И Параметр.ФормаВладелецУИД = ЭтаФорма.УникальныйИдентификатор Тогда
			сабОбщегоНазначения.ПрикрепитьФайлКДокументу(Параметр); 
		КонецЕсли
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
	//	МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
	//	МодульУправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	//КонецЕсли; 
	
	сабОбщегоНазначенияБУХ.ФормаДокументаУУОбработкаБУПередЗаписью(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
	//	МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
	//	МодульУправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	//КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	
	//Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
	//	МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
	//	МодульУправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтотОбъект, Объект.Ссылка);
	//КонецЕсли;
	
КонецПроцедуры


// СтандартныеПодсистемы.КонтактнаяИнформация

// Поддержка дополнительных реквизитов.

&НаСервере
Процедура СвойстваВыполнитьОтложеннуюИнициализацию()
	
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
	//	МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
	//	МодульУправлениеСвойствами.ЗаполнитьДополнительныеРеквизитыВФорме(ЭтотОбъект);
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	
	//Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
	//	МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
	//	МодульУправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	
	//Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
	//	МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
	//	МодульУправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
	//КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
	//	МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
	//	МодульУправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
	//КонецЕсли;
	
КонецПроцедуры




// Конец СтандартныеПодсистемы.КонтактнаяИнформация


&НаКлиенте
Процедура сабПриОткрытии(Отказ)

КонецПроцедуры

&НаСервереБезКонтекста
Функция СчетТовары()
	Возврат ПланыСчетов.Учетный.Счет41()
КонецФункции

&НаСервере
Функция ДокМомент()
	Возврат Объект.Ссылка.МоментВремени();	
КонецФункции


&НаКлиенте
Процедура ТабличнаяЧастьТоварНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	//СтандартнаяОбработка = ЛОЖЬ;
	//Если Объект.Ссылка.Пустая() Тогда
	//	ДатаГраница = КонецДня(Объект.Дата)
	//Иначе
	//	ДатаГраница =  ДокМомент();
	//КонецЕсли;
	//Подр = Объект.Подразделение;
	//Тов = Элементы.ТабличнаяЧасть.ТекущиеДанные.Номенклатура;
	//Парам = Новый Структура("ТекущаяСтрока, ВыбДата,ВыбСчет,ВыбПредприятие,ВыбПодразделение,ВыбСклад",Тов, ДатаГраница,СчетТовары(),Объект.Предприятие,Подр,Объект.Склад);
	//ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаВыбораСОстатками4143",Парам,Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеПриИзменении(Элемент)
	ПредприятиеПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПредприятиеПриИзмененииНаСервере()
	сабОбщегоНазначенияКлиентСервер.СкрытьПодразделения(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура сабПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	БюджетныйНаСервере.ДействияПриСозданииФормыДокумента(ЭтаФорма);
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если ЗначениеЗаполнено(Объект.Подразделение) Тогда
			РеквизитыПодразделения = БюджетныйНаСервере.ВернутьРеквизиты(Объект.Подразделение, "Склад, Организация");
			Объект.Склад = РеквизитыПодразделения.Склад;
			Объект.Организация = РеквизитыПодразделения.Организация;
		КонецЕсли;
	КонецЕсли;
	
	//ОперУчетВключен = Константы.сабМодульОперативныйУчет.Получить();
	//Элементы.ТабличнаяЧастьНоменклатураКод.Видимость = ОперУчетВключен;
	//Элементы.ТабличнаяЧастьНоменклатураНоваяКод.Видимость = ОперУчетВключен;
	
	ИспользоватьСерии = Справочники.СерииНоменклатуры.СерииНоменклатурыИспользуются();
	
КонецПроцедуры


&НаСервере
Процедура сабПриЧтенииНаСервере(ТекущийОбъект)
	сабОбщегоНазначения.ОтобразитьСостояниеДокумента(ЭтаФорма);
КонецПроцедуры


&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	сабОбщегоНазначения.ОтобразитьСостояниеДокумента(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры


&НаКлиенте
Процедура ТабличнаяЧастьМатериалПриИзменении(Элемент)
	
	ТекДанные = Элементы.ТабличнаяЧасть.ТекущиеДанные;
	Если Не ТекДанные = Неопределено Тогда
		ТекДанные.НоменклатураНовая = ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка");
		ТекДанные.КоэффициентПеревода = 0;
		//ТекДанные.НовыйСчетУчетаБУ = ПредопределенноеЗначение("ПланСчетов.Учетный.ПустаяСсылка");
		//ТекДанные.СчетУчетаБУ = сабОбщегоНазначения.ПолучитьСчетУчетаНоменклатуры(ТекДанные.Номенклатура, Объект.Организация, Объект.Склад);
		СтруктураПеревода = ПолучитьСтруктуруПеревода(ТекДанные.Номенклатура, Объект.Дата);
		Если Не СтруктураПеревода = Неопределено Тогда
			ТекДанные.НоменклатураНовая = СтруктураПеревода.Ингридиент;
			ТекДанные.КоэффициентПеревода = СтруктураПеревода.КоэффициентПеревода;
			//ТекДанные.НовыйСчетУчетаБУ = сабОбщегоНазначения.ПолучитьСчетУчетаНоменклатуры(ТекДанные.НоменклатураНовая, Объект.Организация, Объект.Склад);
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСтруктуруПеревода(ТекНоменклатура, ТекДата)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаПереводовВИнгредиентыСрезПоследних.Ингридиент,
	|	ТаблицаПереводовВИнгредиентыСрезПоследних.КоэффициентПеревода
	|ИЗ
	|	РегистрСведений.ТаблицаПереводовВИнгредиенты.СрезПоследних(&Период, Номенклатура = &Номенклатура) КАК ТаблицаПереводовВИнгредиентыСрезПоследних
	|ГДЕ
	|	ВЫБОР
	|			КОГДА ТаблицаПереводовВИнгредиентыСрезПоследних.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ТаблицаПереводовВИнгредиентыСрезПоследних.ДатаОкончания >= &Период
	|		КОНЕЦ";
	Запрос.УстановитьПараметр("Период", ?(ЗначениеЗаполнено(ТекДата), ТекДата, ТекущаяДата()));
	Запрос.УстановитьПараметр("Номенклатура", ТекНоменклатура);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		СтруктураПеревода = Новый Структура;
		СтруктураПеревода.Вставить("Ингридиент", Выборка.Ингридиент);
		СтруктураПеревода.Вставить("КоэффициентПеревода", Выборка.КоэффициентПеревода);
		Возврат СтруктураПеревода;
	КонецЦикла;	
	
КонецФункции	

#Область ПоискПоШК

&НаКлиенте
Процедура ПодобратьНоменклатуруПоШК(Команда)
	ОбработкаТабличнойЧастиТоварыКлиент.ВвестиШтрихкод(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеПоискаПоШтрихкоду(Штрихкод, ДополнительныеПараметры) Экспорт
	
	ИмяТЧ = "ТабличнаяЧасть";
	ИмяРеквизитаНоменклатуры = "Номенклатура";
	ИмяРеквизитаКоличества = "Количество";
	сабОперОбщегоНазначенияНаКлиенте.ОбработатьЗаполнениеПоШтрихкодуНаКлиенте(ЭтаФорма, ИмяТЧ, ИмяРеквизитаНоменклатуры, ИмяРеквизитаКоличества, Штрихкод);
	ТабличнаяЧастьМатериалПриИзменении(Неопределено);
	
КонецПроцедуры
#КонецОбласти

&НаКлиенте
Процедура ТабличнаяЧастьНоменклатураНоваяПриИзменении(Элемент)
	
	//	ТекДанные = Элементы.ТабличнаяЧасть.ТекущиеДанные;
	//Если Не ТекДанные = Неопределено Тогда
	//	ТекДанные.СчетУчетаБУ = сабОбщегоНазначения.ПолучитьСчетУчетаНоменклатуры(ТекДанные.Номенклатура);
	//	ТекДанные.НовыйСчетУчетаБУ = сабОбщегоНазначения.ПолучитьСчетУчетаНоменклатуры(ТекДанные.НоменклатураНовая, Объект.Организация, Объект.Склад);
	//КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьКоличествоПриИзменении(Элемент)
	
	ТекДанные = Элементы.ТабличнаяЧасть.ТекущиеДанные;
	Если Не ТекДанные = Неопределено Тогда
		Если Не ТекДанные.КоэффициентПеревода = 0 Тогда
			ТекДанные.КоличествоНовое = ТекДанные.Количество * ТекДанные.КоэффициентПеревода;
		КонецЕсли;	
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВидДеятельностиПриИзменении(Элемент)
	ПодразделениеПриИзмененииСервер();
КонецПроцедуры

&НаСервере
Процедура ПодразделениеПриИзмененииСервер()
	Если ЗначениеЗаполнено(Объект.Подразделение) Тогда
		РеквизитыПодразделения = БюджетныйНаСервере.ВернутьРеквизиты(Объект.Подразделение, "Склад, Организация");
		Объект.Склад = РеквизитыПодразделения.Склад;
		Объект.Организация = РеквизитыПодразделения.Организация;
	КонецЕсли; 
КонецПроцедуры

#Область ПодборТоваров
&НаКлиенте
Процедура ПодборТовары(Команда)

	ПараметрыПодбора = ПолучитьПараметрыПодбора("ТабличнаяЧасть");
	Если ПараметрыПодбора <> Неопределено Тогда
		ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.Форма", ПараметрыПодбора,
			ЭтаФорма, УникальныйИдентификатор);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораПодборВставкаИзБуфераНаСервере(ВыбранноеЗначение, ИмяТаблицы)

	ЭтоВставкаИзБуфера = ВыбранноеЗначение.Свойство("ЭтоВставкаИзБуфера");
	СписокСвойств = Неопределено;
	Если ЭтоВставкаИзБуфера Тогда
		
		ТаблицаТоваров = ВыбранноеЗначение.Данные;
		СписокСвойств = ВыбранноеЗначение.СписокСвойств;
		
	Иначе
		
		ТаблицаТоваров = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресПодобраннойНоменклатурыВХранилище);
		
	КонецЕсли;
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	//СоответствиеСведенийОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОСпискеНоменклатуры(
	//	ОбщегоНазначения.ВыгрузитьКолонку(ТаблицаТоваров, "Номенклатура", Истина), ДанныеОбъекта, Ложь);
	
	//ЗаполнитьСтавкиНДСВРознице	= НТТ И УчетВПродажныхЦенах И РазделятьПоСтавкамНДС;
	ЗаполнитьСтавкиНДСВРознице = Ложь;
	
	СтрокиДляЗаполненияСчетов = Новый Массив;
	
	Для каждого СтрокаТовара Из ТаблицаТоваров Цикл
		
		СведенияОНоменклатуре = БюджетныйНаСервере.ВернутьРеквизиты(СтрокаТовара.Номенклатура, "ЕдиницаИзмерения, Счет10, СтавкаНДС");
		//Если ЭтоВставкаИзБуфера
		//	И СведенияОНоменклатуре <> Неопределено
		//	И ЗначениеЗаполнено(СведенияОНоменклатуре.Услуга)
		//	И СведенияОНоменклатуре.Услуга Тогда
		//	
		//	Продолжить;
		//	
		//КонецЕсли;
		СтрокаТабличнойЧасти = Объект[ИмяТаблицы].Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаТовара, СписокСвойств);
		СтрокиДляЗаполненияСчетов.Добавить(СтрокаТабличнойЧасти);
		
		Если СведенияОНоменклатуре = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		//Если ИмяТаблицы = "ТабличнаяЧасть" Тогда
			
			//СтрокаТабличнойЧасти.ЕдиницаИзмерения		= ?(ЗначениеЗаполнено(СтрокаТабличнойЧасти.ЕдиницаИзмерения),
			//	СтрокаТабличнойЧасти.ЕдиницаИзмерения, СведенияОНоменклатуре.ЕдиницаИзмерения);
			//СтрокаТабличнойЧасти.Коэффициент			= ?(ЗначениеЗаполнено(СтрокаТабличнойЧасти.Коэффициент),
			//	СтрокаТабличнойЧасти.Коэффициент, СведенияОНоменклатуре.Коэффициент);
			//СтрокаТабличнойЧасти.НомерГТД				= ?(ЗначениеЗаполнено(СтрокаТабличнойЧасти.НомерГТД),
			//	СтрокаТабличнойЧасти.НомерГТД, СведенияОНоменклатуре.НомерГТД);
			//СтрокаТабличнойЧасти.СтранаПроисхождения	= ?(ЗначениеЗаполнено(СтрокаТабличнойЧасти.СтранаПроисхождения),
			//	СтрокаТабличнойЧасти.СтранаПроисхождения, СведенияОНоменклатуре.СтранаПроисхождения);
			
			//СтрокаТабличнойЧасти.Товар		= ?(ЗначениеЗаполнено(СтрокаТабличнойЧасти.Товар),
			//	СтрокаТабличнойЧасти.Товар, СтрокаТовара.Номенклатура);
			СтрокаТабличнойЧасти.СчетУчетаБУ		= ?(ЗначениеЗаполнено(СтрокаТабличнойЧасти.СчетУчетаБУ),
				СтрокаТабличнойЧасти.СчетУчетаБУ, СведенияОНоменклатуре.Счет10);
			СтрокаТабличнойЧасти.НовыйСчетУчетаБУ		= ?(ЗначениеЗаполнено(СтрокаТабличнойЧасти.НовыйСчетУчетаБУ),
				СтрокаТабличнойЧасти.НовыйСчетУчетаБУ, СведенияОНоменклатуре.Счет10);
			//СтрокаТабличнойЧасти.СтавкаНДС		= ?(ЗначениеЗаполнено(СтрокаТабличнойЧасти.СтавкаНДС),
			//	СтрокаТабличнойЧасти.СтавкаНДС, СведенияОНоменклатуре.СтавкаНДС);
			//Если НТТ Тогда
			//		
			//	СтрокаТабличнойЧасти.Цена = ?(ЗначениеЗаполнено(СтрокаТабличнойЧасти.Цена),
			//		СтрокаТабличнойЧасти.Цена, СведенияОНоменклатуре.ЦенаВРознице);
			//		
			//	Если ЗаполнитьСтавкиНДСВРознице Тогда
			//		СтрокаТабличнойЧасти.СтавкаНДСВРознице = СведенияОНоменклатуре.СтавкаНДСВРознице;
			//	КонецЕсли;
			//	
			//КонецЕсли;
			
			//СтрокаТабличнойЧасти.ОтражениеВУСН = Перечисления.ОтражениеВУСН.НеПринимаются;
			
			//ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти);
			
		//КонецЕсли;
		
	КонецЦикла;
	
	//СчетаУчетаВДокументах.ЗаполнитьСтроки(СтрокиДляЗаполненияСчетов, ИмяТаблицы, Объект, Документы.СписаниеТоваров);
	
	Если ЭтоВставкаИзБуфера Тогда
		
		ВыбранноеЗначение.КоличествоДобавленныхСтрок = СтрокиДляЗаполненияСчетов.Количество();
		
	КонецЕсли;
	
	//ЗаполнитьДобавленныеКолонкиТаблиц();
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПараметрыПодбора(ИмяТаблицы)

	ДатаРасчетов		= ?(НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДата()),ТекущаяДата(), Объект.Дата);
	
	ЗаголовокПодбора	= НСтр("ru = 'Подбор номенклатуры в %1 (%2)'");
	Если ИмяТаблицы = "Товары" Тогда
		ПредставлениеТаблицы = НСтр("ru = 'Товары'");
	ИначеЕсли ИмяТаблицы = "ВозвратнаяТара" Тогда
		ПредставлениеТаблицы = НСтр("ru = 'Возвратная тара'");
	КонецЕсли;
	ЗаголовокПодбора = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ЗаголовокПодбора, Объект.Ссылка, ПредставлениеТаблицы);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДатаРасчетов"  , ДатаРасчетов);
	ПараметрыФормы.Вставить("Валюта"        , ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
	ПараметрыФормы.Вставить("Организация"   , Объект.Организация);
	ПараметрыФормы.Вставить("Подразделение" , Объект.Подразделение);
	ПараметрыФормы.Вставить("Склад"         , Объект.Склад);
	ПараметрыФормы.Вставить("Заголовок"     , ЗаголовокПодбора);
	ПараметрыФормы.Вставить("ВидПодбора"    , "");
	ПараметрыФормы.Вставить("ИмяТаблицы"    , ИмяТаблицы);
	ПараметрыФормы.Вставить("Услуги"        , ИмяТаблицы = "Услуги");
	ПараметрыФормы.Вставить("ПоказыватьОстатки"  , Истина);
	ПараметрыФормы.Вставить("ЕстьКоличество", Истина);
	ПараметрыФормы.Вставить("Предприятие" , Объект.Предприятие);
	
	Возврат ПараметрыФормы;

КонецФункции

#КонецОбласти 

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборНоменклатуры.Форма.Форма" Тогда
		ОбработкаВыбораПодборВставкаИзБуфераНаСервере(ВыбранноеЗначение, ИсточникВыбора.ИмяТаблицы);
	КонецЕсли;
КонецПроцедуры


#Область КомандыИзменения

&НаКлиенте
Процедура ПоказатьИзмененияВерсий(ИмяКоманды)

	СсылкаНаОбъект = ЭтаФорма.ДокументБУ; 
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Ссылка",СсылкаНаОбъект);
	СтруктураКоличествВерсий = сабОбщегоНазначенияБУХ.ПолучитьКоличествоВерсий(СсылкаНаОбъект);
	КолВерсий = СтруктураКоличествВерсий.КоличествоИзмененныхВерсий;
	СравниваемыеВерсии = Новый СписокЗначений;  
	Пока КолВерсий > 0 Цикл
		СравниваемыеВерсии.Добавить(СтруктураКоличествВерсий.КоличествоВерсий, СтруктураКоличествВерсий.КоличествоВерсий);
		СтруктураКоличествВерсий.КоличествоВерсий = СтруктураКоличествВерсий.КоличествоВерсий - 1;
		КолВерсий = КолВерсий - 1;
	КонецЦикла;
	ПараметрыОтчета.Вставить("СравниваемыеВерсии",СравниваемыеВерсии); 
	
	ОткрытьФорму("РегистрСведений.ВерсииОбъектов.Форма.ОтчетПоВерсиямОбъекта", ПараметрыОтчета);

КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьПоДокументу(ИмяКоманды)

	ПерезаполнитьДокументНаОснованиинаСервере();
	
	Модифицированность = Истина;

КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьДокументНаОснованиинаСервере()
	
	ТекОбъект = РеквизитФормыВЗначение("Объект");
	ТекОбъект.ОбработкаЗаполненияСФормы(ЭтаФорма.ДокументБУ, Неопределено, Истина);
	ЗначениеВРеквизитФормы(ТекОбъект, "Объект");
	
	//ОбновленнаяЗапись = РегистрыСведений.сабОбработкаДокументов.СоздатьМенеджерЗаписи();
	//ОбновленнаяЗапись.ДокументБУ = ЭтаФорма.ДокументБУ;
	//ОбновленнаяЗапись.ДокументУУ = Объект.Ссылка;
	//ОбновленнаяЗапись.ДатаОбработки = ТекущаяДата();
	//ОбновленнаяЗапись.Автор = ПараметрыСеанса.ТекущийПользователь;
	//ОбновленнаяЗапись.Модифицирован = Ложь;
	//ОбновленнаяЗапись.Записать();
	Элементы.ЭлементПерезаполнитьПоДокументу.Доступность = Ложь;
	
	ПриЧтенииНаСервере(Неопределено);
	ПриСозданииНаСервере(Ложь, Истина);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ОповеститьРегистрОбработанных", Новый Структура("ДокументУУ, ДокументБУ", Объект.Ссылка, ?(БюджетныйНаКлиенте.ЕстьСвойствоОбъекта(ЭтаФорма, "ДокументБУ"), ЭтаФорма.ДокументБУ, Неопределено)));	
КонецПроцедуры

#Область ПодборТоваров

&НаКлиенте
Процедура Подобрать(Команда)
	
	ОписаниеОповещенияПослеПодбора = Новый ОписаниеОповещения("ЗаполнитьТоварыПоПодбору",ЭтотОбъект);
	СтруктураПараметров = Новый Структура("Склад,Предприятие,Заголовок",Объект.Склад,Объект.Предприятие, "Подбор товаров для документа " + Объект.Ссылка);
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаДляПодбора",СтруктураПараметров,ЭтотОбъект,УникальныйИдентификатор,,,ОписаниеОповещенияПослеПодбора,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры 

&НаКлиенте
Процедура ЗаполнитьТоварыПоПодбору(Результат,ДопПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Если ЭтоАдресВременногоХранилища(Результат) Тогда
			ЗаполнитьПоПодборуНаСервере(Результат);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоПодборуНаСервере(АдресВХ)
	
	ТЗДанныеПодбора = ПолучитьИзВременногоХранилища(АдресВХ);	
	Если ТипЗнч(ТЗДанныеПодбора) = Тип("ТаблицаЗначений") Тогда
		Для Каждого СтрокаТовара Из ТЗДанныеПодбора Цикл
			НайденныеСтроки = Объект.ТабличнаяЧасть.НайтиСтроки(Новый Структура("Номенклатура,Цена",СтрокаТовара.Номенклатура,СтрокаТовара.Цена));
			Если НайденныеСтроки.Количество() > 0 Тогда 
				ТекДанные = НайденныеСтроки[0];
				//Если АльтернативнаяФорма Тогда
						ТекДанные.Количество = ТекДанные.Количество + СтрокаТовара.Количество; 
				//Иначе
				//	ТекДанные.КоличествоУпаковок = ТекДанные.КоличествоУпаковок + СтрокаТовара.Количество; 
				//	ТекДанные.Количество = ТекДанные.КоэффициентПересчетаУпаковок * ТекДанные.КоличествоУпаковок;
				//КонецЕсли;
				ТекДанные.Сумма = ТекДанные.Количество * ТекДанные.Цена;
				//ТекРеквизиты = БюджетныйНаСервере.ВернутьРеквизиты(ТекДанные.СтавкаНДС, "Ставка");
				//Если НЕ ТекРеквизиты = Неопределено Тогда
				//	ТекДанные.СуммаНДС = ТекДанные.Сумма / ((100+ТекРеквизиты.Ставка)/100) * (ТекРеквизиты.Ставка/100);
				//КонецЕсли;
				//Если АльтернативнаяФорма Тогда
				//	Если ТипЗнч(ТекДанные.ЕдиницаИзмерения) = Тип("СправочникСсылка.КлассификаторЕдиницИзмерения") Тогда
				//		СтруктураВозврата = ПолучитьКоличествоВУпаковкеПоУмолчаниюДляНоменклатуры(ТекДанные.Номенклатура);
				//		ТекДанные.КоэффициентПересчетаУпаковок = СтруктураВозврата.Коэффициент;
				//		ПредставлениеУпаковки = СтруктураВозврата.Упаковка;
				//		ПредставлениеЕдИзмерения = ТекДанные.ЕдиницаИзмерения; 
				//	Иначе
				//		ТекДанные.КоэффициентПересчетаУпаковок = ПолучитьКоэффициентПересчетаУпаковок(ТекДанные.Номенклатура, ТекДанные.ЕдиницаИзмерения);
				//		ПредставлениеУпаковки = ТекДанные.ЕдиницаИзмерения; 
				//		ПредставлениеЕдИзмерения = ПолучитьПредставлениеЕдиницыУпаковки(ТекДанные.Номенклатура,ТекДанные.ЕдиницаИзмерения);
				//	КонецЕсли;
				//	ТекДанные.КоличествоВУпаковке = ТекДанные.КоэффициентПересчетаУпаковок;
				//	ТекДанные.КоличествоУпаковок = Цел(?(ТекДанные.КоэффициентПересчетаУпаковок = 0,0,ТекДанные.Количество / ТекДанные.КоэффициентПересчетаУпаковок)); 
				//	Если ТекДанные.КоличествоВУпаковке = 0 ИЛИ ТекДанные.КоличествоВУпаковке = 1 Тогда
				//		КолУпаковок = 0;
				//		КолЕдиниц = ТекДанные.Количество;
				//		ТекДанные.КоличествоУпаковокПредставление = "" + КолУпаковок + " " + ПредставлениеУпаковки + ","  +
				//		КолЕдиниц + " " + ПредставлениеЕдИзмерения;
				//	Иначе
				//		КолУпаковок = Цел(ТекДанные.Количество / ТекДанные.КоличествоВУпаковке);
				//		КолЕдиниц = ТекДанные.Количество - (КолУпаковок * ТекДанные.КоличествоВУпаковке);
				//		ТекДанные.КоличествоУпаковокПредставление = "" + КолУпаковок + " " + ПредставлениеУпаковки + ", " +
				//		КолЕдиниц + " " + ПредставлениеЕдИзмерения;
				//	КонецЕсли;
				//	
				//КонецЕсли;
			Иначе
				НоваяСтрокаТовары = Объект.ТабличнаяЧасть.Добавить();
				НоваяСтрокаТовары.Номенклатура = СтрокаТовара.Номенклатура;
				НоваяСтрокаТовары.Цена = СтрокаТовара.Цена;
				ТекДанные = НоваяСтрокаТовары; 
				//Установим единицу измерения по умолчанию
				//Если АльтернативнаяФорма Тогда
				//	ТекДанные.ЕдиницаИзмерения = НоваяСтрокаТовары.Номенклатура.ЕдиницаИзмерения;
				//Иначе
				//ТекДанные.ЕдиницаИзмерения = ПолучитьЕдИзмНоменклатуры(ТекДанные.Номенклатура);
				//КонецЕсли;
				//МассивЕдИзмНоменклатуры = ПолучитьМассивВозможныхЕдиницИзмеренияНоменклатуры(ТекДанные.Номенклатура);
				//Элементы.ТабличнаяЧастьЕдиницаИзмерения.СписокВыбора.Очистить();
				//Для Каждого ЭлементВыборкаЕдИзм Из МассивЕдИзмНоменклатуры Цикл
				//	Элементы.ТабличнаяЧастьЕдиницаИзмерения.СписокВыбора.Добавить(ЭлементВыборкаЕдИзм);
				//КонецЦикла;
				//ТекДанные.КоэффициентПересчетаУпаковок = ПолучитьКоэффициентПересчетаУпаковок(ТекДанные.Номенклатура, ТекДанные.ЕдиницаИзмерения);
				//Если АльтернативнаяФорма Тогда 
					ТекДанные.Количество = СтрокаТовара.Количество;
				//	ЗаполнитьПредставлениеУпаковок(ТекДанные);
				//Иначе 
				//	ТекДанные.КоэффициентПересчетаУпаковок = ПолучитьКоэффициентПересчетаУпаковок(ТекДанные.Номенклатура, ТекДанные.ЕдиницаИзмерения);
				//	ТекДанные.КоличествоУпаковок = СтрокаТовара.Количество; 
				//	ТекДанные.Количество = ТекДанные.КоэффициентПересчетаУпаковок * ТекДанные.КоличествоУпаковок;
				//КонецЕсли;  
				//ТекДанные.КоличествоВУпаковке = ТекДанные.КоэффициентПересчетаУпаковок;  
				ТекДанные.Сумма = ТекДанные.Количество * ТекДанные.Цена;
				
				////Установим НДС и артикул
				//Если ЗначениеЗаполнено(ТекДанные.Номенклатура) Тогда
				//	ТекРеквизиты = БюджетныйНаСервере.ВернутьРеквизиты(ТекДанные.Номенклатура, "СтавкаНДС, Код, Счет10, ВидСтавкиНДС, ЕдиницаИзмерения, Кратность, МинимальнаяПартия", Ложь);
				//	ТекДанные.СтавкаНДС = сабОбщегоНазначенияБУХПовтИсп.СоотвВидовСтавокНДСБУХУУ().Получить(ТекРеквизиты.ВидСтавкиНДС);;
				//	//ТекДанные.Кратность = ТекРеквизиты.Кратность; 
				//	ТекРеквизиты = БюджетныйНаСервере.ВернутьРеквизиты(ТекДанные.СтавкаНДС, "Ставка");
				//	Если НЕ ТекРеквизиты = Неопределено Тогда
				//		ТекДанные.СуммаНДС = ТекДанные.Сумма / ((100+ТекРеквизиты.Ставка)/100) * (ТекРеквизиты.Ставка/100);
				//	КонецЕсли;
				//КонецЕсли;
				//Если ЗначениеЗаполнено(Объект.Склад) Тогда
				//	ТекДанные.Склад = Объект.Склад;	
				//КонецЕсли;
				СтруктураДанных =Новый Структура("Номенклатура, Количество", 
				ТекДанные.Номенклатура, ТекДанные.Количество);
				//ЗаполнитьОстаткиИРезервы(Истина, СтруктураДанных);
				//ЗаполнитьКонтрольМинЦены(Истина, СтруктураДанных);
				ЗаполнитьЗначенияСвойств(ТекДанные, СтруктураДанных);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаСервереБезКонтекста
Функция ПолучитьКоличествоВУпаковкеПоУмолчаниюДляНоменклатуры(Номенклатура) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УпаковкиНоменклатуры.Коэффициент КАК Коэффициент,
	|	УпаковкиНоменклатуры.ОсновнаяУпаковка КАК ОсновнаяУпаковка,
	|	УпаковкиНоменклатуры.Упаковка.Представление КАК Упаковка
	|ИЗ
	|	РегистрСведений.УпаковкиНоменклатуры КАК УпаковкиНоменклатуры
	|ГДЕ
	|	УпаковкиНоменклатуры.Номенклатура = &Номенклатура";
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	СтруктураВозврата = Новый Структура("Упаковка,Коэффициент");
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Количество() > 1 Тогда
		Пока Выборка.Следующий() Цикл
			Если Выборка.ОсновнаяУпаковка Тогда
				СтруктураВозврата.Упаковка = Выборка.Упаковка;
				СтруктураВозврата.Коэффициент = Выборка.Коэффициент;
				Возврат СтруктураВозврата; 
			КонецЕсли;
		КонецЦикла;
		Выборка.Сбросить();
		Выборка.Следующий(); 
		СтруктураВозврата.Упаковка = Выборка.Упаковка;
		СтруктураВозврата.Коэффициент = Выборка.Коэффициент;
		Возврат СтруктураВозврата; 
	Иначе
		Если Выборка.Следующий() Тогда
			СтруктураВозврата.Упаковка = Выборка.Упаковка;
			СтруктураВозврата.Коэффициент = Выборка.Коэффициент;
			Возврат СтруктураВозврата; 
		КонецЕсли;
	КонецЕсли; 
	СтруктураВозврата.Упаковка = "уп.";
	СтруктураВозврата.Коэффициент = 1;
	Возврат СтруктураВозврата; 
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьКоэффициентПересчетаУпаковок(Номенклатура, ЕдиницаИзмерения) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УпаковкиНоменклатуры.Коэффициент
	|ИЗ
	|	РегистрСведений.УпаковкиНоменклатуры КАК УпаковкиНоменклатуры
	|ГДЕ
	|	УпаковкиНоменклатуры.Номенклатура = &Номенклатура
	|	И УпаковкиНоменклатуры.Упаковка = &Упаковка
	|	И УпаковкиНоменклатуры.ЕдиницаИзмерения = &ЕдиницаИзмерения";
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Упаковка", ЕдиницаИзмерения);
	Запрос.УстановитьПараметр("ЕдиницаИзмерения", Номенклатура.ЕдиницаИзмерения);
	
	Выборка = запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Возврат Выборка.Коэффициент;		
	КонецЦикла;
	
	Возврат 1;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьПредставлениеЕдиницыУпаковки(Номенклатура = Неопределено, ЕдиницаИзмерения = Неопределено, ДляОднойНоменклатуры = Истина, ТЗДанные = Неопределено) Экспорт
	
	Если ДляОднойНоменклатуры Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	УпаковкиНоменклатуры.ЕдиницаИзмерения.Представление КАК ЕдиницаИзмерения 
		|ИЗ
		|	РегистрСведений.УпаковкиНоменклатуры КАК УпаковкиНоменклатуры
		|ГДЕ
		|	УпаковкиНоменклатуры.Номенклатура = &Номенклатура
		|	И УпаковкиНоменклатуры.Упаковка = &Упаковка";
		Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
		Запрос.УстановитьПараметр("Упаковка", ЕдиницаИзмерения);
		
		Выборка = запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Возврат Выборка.ЕдиницаИзмерения;		
		КонецЦикла;
		
		Возврат ЕдиницаИзмерения.Наименование;
	Иначе
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТЗНоменклатураУпаковки.Номенклатура КАК Номенклатура,
		|	ТЗНоменклатураУпаковки.ЕдиницаИзмерения КАК Упаковка
		|ПОМЕСТИТЬ ВТНоменклатураУпаковка
		|ИЗ
		|	&ТЗНоменклатураУпаковки КАК ТЗНоменклатураУпаковки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЕСТЬNULL(УпаковкиНоменклатуры.ЕдиницаИзмерения.Представление, ВТНоменклатураУпаковка.Упаковка) КАК ЕдиницаИзмерения, 
		|	ВТНоменклатураУпаковка.Упаковка КАК Упаковка,
		|	ВТНоменклатураУпаковка.Упаковка.Представление КАК УпаковкаПредставление,
		|	ВТНоменклатураУпаковка.Номенклатура КАК Номенклатура
		|ИЗ
		|	ВТНоменклатураУпаковка КАК ВТНоменклатураУпаковка
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УпаковкиНоменклатуры КАК УпаковкиНоменклатуры
		|		ПО ВТНоменклатураУпаковка.Номенклатура = УпаковкиНоменклатуры.Номенклатура
		|			И ВТНоменклатураУпаковка.Упаковка = УпаковкиНоменклатуры.Упаковка";
		Запрос.УстановитьПараметр("ТЗНоменклатураУпаковки",ТЗДанные);
		
		Выборка = запрос.Выполнить().Выбрать();
		Возврат Выборка;
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьЕдИзмНоменклатуры(Номенклатура) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УпаковкиНоменклатуры.Упаковка
	|ИЗ
	|	РегистрСведений.УпаковкиНоменклатуры КАК УпаковкиНоменклатуры
	|ГДЕ
	|	УпаковкиНоменклатуры.Номенклатура = &Номенклатура
	|	И УпаковкиНоменклатуры.ОсновнаяУпаковка";
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	Выборка = запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Возврат Выборка.Упаковка;		
	КонецЦикла;	
	
	Возврат Номенклатура.ЕдиницаИзмерения;	
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьМассивВозможныхЕдиницИзмеренияНоменклатуры(Номенклатура) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УпаковкиНоменклатуры.Упаковка
	|ИЗ
	|	РегистрСведений.УпаковкиНоменклатуры КАК УпаковкиНоменклатуры
	|ГДЕ
	|	УпаковкиНоменклатуры.Номенклатура = &Номенклатура"; 
	АльтернативнаяФорма = Справочники.сабМониторВнедрения.ПолучитьЗначениеНастройки("АльтернативнаяФормаЗаказов");
	Если АльтернативнаяФорма Тогда
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	УпаковкиНоменклатуры.ЕдиницаИзмерения КАК Упаковка
		|ИЗ
		|	РегистрСведений.УпаковкиНоменклатуры КАК УпаковкиНоменклатуры
		|ГДЕ
		|	УпаковкиНоменклатуры.Номенклатура = &Номенклатура
		|	И УпаковкиНоменклатуры.ЕдиницаИзмерения <> &ЕдиницаИзмерения"; 
		Запрос.УстановитьПараметр("ЕдиницаИзмерения", Номенклатура.ЕдиницаИзмерения);
	КонецЕсли;
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	АльтернативнаяФорма = Справочники.сабМониторВнедрения.ПолучитьЗначениеНастройки("АльтернативнаяФормаЗаказов");
	ТаблицаУпаковок = Запрос.Выполнить().Выгрузить();
	ТаблицаУпаковок.Свернуть("Упаковка");
	МассивУпаковок = ТаблицаУпаковок.ВыгрузитьКолонку("Упаковка");
	МассивУпаковок.Вставить(0, Номенклатура.ЕдиницаИзмерения);
	Возврат МассивУпаковок;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьПредставлениеУпаковок(ТекДанные)
	
	Если ТипЗнч(ТекДанные.ЕдиницаИзмерения) = Тип("СправочникСсылка.КлассификаторЕдиницИзмерения") Тогда
		СтруктураВозврата =ПолучитьКоличествоВУпаковкеПоУмолчаниюДляНоменклатуры(ТекДанные.Номенклатура);
		ТекДанные.КоэффициентПересчетаУпаковок = СтруктураВозврата.Коэффициент;
		ПредставлениеУпаковки = СтруктураВозврата.Упаковка;
		ПредставлениеЕдИзмерения = ТекДанные.ЕдиницаИзмерения; 
	Иначе
		ТекДанные.КоэффициентПересчетаУпаковок = ПолучитьКоэффициентПересчетаУпаковок(ТекДанные.Номенклатура, ТекДанные.ЕдиницаИзмерения);
		ПредставлениеУпаковки = ТекДанные.ЕдиницаИзмерения; 
		ПредставлениеЕдИзмерения = ПолучитьПредставлениеЕдиницыУпаковки(ТекДанные.Номенклатура,ТекДанные.ЕдиницаИзмерения);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекДанные.ЕдиницаИзмерения) И ЗначениеЗаполнено(ТекДанные.КоэффициентПересчетаУпаковок) Тогда
		ТекДанные.КоличествоВУпаковкеПредставление = "(" +  Строка(ТекДанные.КоэффициентПересчетаУпаковок) + " " + ПредставлениеЕдИзмерения +")";
	Иначе
		ТекДанные.КоличествоВУпаковкеПредставление = Строка(ТекДанные.КоэффициентПересчетаУпаковок);
	КонецЕсли;
	Если ТекДанные.КоэффициентПересчетаУпаковок = 0 ИЛИ ТекДанные.КоэффициентПересчетаУпаковок = 1 Тогда
		КолУпаковок = 0;
		КолЕдиниц = ТекДанные.Количество;
		ТекДанные.КоличествоУпаковокПредставление = "" + КолУпаковок + " "  + ПредставлениеУпаковки + "," +
		КолЕдиниц + " " + ПредставлениеЕдИзмерения;
	Иначе
		КолУпаковок = Цел(ТекДанные.Количество / ТекДанные.КоэффициентПересчетаУпаковок);
		КолЕдиниц = ТекДанные.Количество - (КолУпаковок * ТекДанные.КоэффициентПересчетаУпаковок);
		ТекДанные.КоличествоУпаковокПредставление = "" + КолУпаковок + " " + ПредставлениеУпаковки + ", " +
		КолЕдиниц + " " + ПредставлениеЕдИзмерения;
	КонецЕсли; 
	ТекДанные.КоличествоУпаковок = Цел(?(ТекДанные.КоэффициентПересчетаУпаковок = 0,0,ТекДанные.Количество / ТекДанные.КоэффициентПересчетаУпаковок)); 
    ТекДанные.КоличествоВУпаковке = ТекДанные.КоэффициентПересчетаУпаковок;
	
КонецПроцедуры

