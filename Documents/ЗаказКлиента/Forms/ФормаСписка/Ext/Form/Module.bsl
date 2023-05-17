﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БюджетныйНаСервере.ДействияПриСозданииФормыДокумента(ЭтаФорма);
	
	Если Параметры.Свойство("ВидЗаказа") Тогда
		ЭлементыДляУдаления = Новый Массив;
		
		ЭлементыОтбора = Список.Отбор.Элементы;
		ПолеКомпоновки = Новый ПолеКомпоновкиДанных("ВидОперации");
		Для Каждого ЭлементОтбора Из ЭлементыОтбора Цикл
			Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных")
				И ЭлементОтбора.ЛевоеЗначение = ПолеКомпоновки Тогда
				ЭлементыДляУдаления.Добавить(ЭлементОтбора);
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого ЭлементОтбораДляУдаления Из ЭлементыДляУдаления Цикл
			ЭлементыОтбора.Удалить(ЭлементОтбораДляУдаления);
		КонецЦикла;	
		
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ВидОперации");	
		ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование  = Истина;
		Если Параметры.ВидЗаказа = "ЗаказНаПеремещение" Тогда
			ЭлементОтбора.ПравоеЗначение = Перечисления.ВидыЗаказов.ВнутреннееПеремещение;
			Если НЕ Элементы.Найти("ФормаДокументУЧ_ВозвратТоваровПоставщикуСоздатьНаОсновании") = Неопределено Тогда
				Элементы.ФормаДокументУЧ_ВозвратТоваровПоставщикуСоздатьНаОсновании.Видимость = Ложь;
			КонецЕсли;
			Если НЕ Элементы.Найти("ФормаДокументУЧ_ПоступлениеТоваровСоздатьНаОсновании") = Неопределено Тогда
				Элементы.ФормаДокументУЧ_ПоступлениеТоваровСоздатьНаОсновании.Видимость = Ложь;
			КонецЕсли;
		ИначеЕсли Параметры.ВидЗаказа = "ЗаказПоставщику" Тогда
			ЭлементОтбора.ПравоеЗначение = Перечисления.ВидыЗаказов.ЗакупкаТоваров;
			Если НЕ Элементы.Найти("ФормаДокументУЧ_ВозвратТоваровПоставщикуСоздатьНаОсновании") = Неопределено Тогда
				Элементы.ФормаДокументУЧ_ВозвратТоваровПоставщикуСоздатьНаОсновании.Видимость = Ложь;
			КонецЕсли;
			Если НЕ Элементы.Найти("ФормаДокументУЧ_ПеремещениеТоваровСоздатьНаОсновании") = Неопределено Тогда
				Элементы.ФормаДокументУЧ_ПеремещениеТоваровСоздатьНаОсновании.Видимость = Ложь;
			КонецЕсли;
			Если НЕ Элементы.Найти("ФормаДокументУЧ_РеализацияСоздатьНаОсновании") = Неопределено Тогда
				Элементы.ФормаДокументУЧ_РеализацияСоздатьНаОсновании.Видимость = Истина;
			КонецЕсли;
		ИначеЕсли Параметры.ВидЗаказа = "ЗаказНаВозврат" Тогда
			ЭлементОтбора.ПравоеЗначение = Перечисления.ВидыЗаказов.ВозвратБрака;
			Если НЕ Элементы.Найти("ФормаДокументУЧ_ПоступлениеТоваровСоздатьНаОсновании") = Неопределено Тогда
				Элементы.ФормаДокументУЧ_ПоступлениеТоваровСоздатьНаОсновании.Видимость = Ложь;
			КонецЕсли;
			Если НЕ Элементы.Найти("ФормаДокументУЧ_ПеремещениеТоваровСоздатьНаОсновании") = Неопределено Тогда
				Элементы.ФормаДокументУЧ_ПеремещениеТоваровСоздатьНаОсновании.Видимость = Ложь;
			КонецЕсли;
			Если НЕ Элементы.Найти("ФормаДокументУЧ_РеализацияСоздатьНаОсновании") = Неопределено Тогда
				Элементы.ФормаДокументУЧ_РеализацияСоздатьНаОсновании.Видимость = Ложь;
			КонецЕсли;
		КонецЕсли;	
	КонецЕсли;
	
	//Элементы.ФормаЗагрузитьЗаказыИзExcel.Видимость = (ПравоДоступа("Использование", Метаданные.Обработки.ЗагрузкаКарточкиExcel));		
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	
	Если РольДоступна("сабМенеджерПоПродажам") Тогда
		ТолькоМои = Истина;
		Элементы.ТолькоМои.Доступность = РольДоступна("сабРуководительПоПродажам");
		ТолькоОткрытые = Истина;
	КонецЕсли;
	Список.Параметры.УстановитьЗначениеПараметра("ТолькоМои", ТолькоМои);
	Список.Параметры.УстановитьЗначениеПараметра("ТолькоОткрытые", ТолькоОткрытые);
	Список.Параметры.УстановитьЗначениеПараметра("Пользователи", БПСервер.ПолучитьМассивПользователей());
	Список.Параметры.УстановитьЗначениеПараметра("НеВМЛ", НеВМЛ);
	
	ВидимостьПредприятия = БюджетныйНаСервере.ПолучитьПредприятия().Количество() > 1;
	
	ЗаблокироватьРеквизитыЗаказа = РольДоступна("допЗапретРедактированияЦенВЗаказе");
	РазрешитьСменуСтатусаЗаказа = РольДоступна("допИзменениеСтатусаЗаказаКлиента");
	
	Элементы.ФормаГруппа2.Доступность = Не ЗаблокироватьРеквизитыЗаказа Или РазрешитьСменуСтатусаЗаказа;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьЗаказыИзExcel(Команда)
	//ОткрытьФорму("Обработка.ЗагрузкаЗаказовПоставщикуИзExcel.Форма.Форма");
	ФормаЗагрузки = ПолучитьФорму("ОбщаяФорма.ФормаЗагрузкиИзExcel", Новый Структура("ВидЗагрузки", "ЗагрузкаВТЧЗаказКлиента"));
	
	ПутьКФайлу = ФормаЗагрузки.ОткрытьМодально();
	
	Если ЗначениеЗаполнено(ПутьКФайлу) Тогда
		//ДокОбъект = _УстановитьДокументПоСсылке(ЭтотОбъект.ТекущийЭлемент.ТекущаяСтрока);
		//Форма = ДокОбъект.ПолучитьФорму("ФормаДокумента");
		СтруктураВозврата = ФормаЗагрузки.ПолучитьДанныеПоЗагрузке(ПутьКФайлу);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ", ЭтотОбъект.ТекущийЭлемент.ТекущаяСтрока);
		
		ФормаДок = ОткрытьФорму("Документ.ЗаказКлиента.Форма.ФормаДокумента", ПараметрыФормы);
		
		//Об = РеквизитФормыВЗначение("Объект");
		//Об = ДанныеФормыВЗначение("Объект");
		Для Каждого ЭлементСтруктурыВозврата Из СтруктураВозврата Цикл
			ТекДанные = ФормаДок.Объект.ТабличнаяЧасть.Добавить();
			ЗаполнитьЗначенияСвойств(ТекДанные, ЭлементСтруктурыВозврата.Значение);
			ФормаДок.УстановитьЗависимыеДанныеВТЧ(ТекДанные);
			ФормаДок.РассчитатьСумму(ТекДанные);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция _УстановитьДокументПоСсылке(_Ссылка)
    Возврат _Ссылка.ПолучитьОбъект();
КонецФункции

&НаКлиенте
Процедура СтатусСогласовано(Команда)
	ВыдСтроки = Элементы.Список.ВыделенныеСтроки;
	СтатусСогласованоНаСервере(ВыдСтроки, Команда.Имя);
	Элементы.Список.Обновить();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СтатусСогласованоНаСервере(Заявки, ИмяКоманды)
	
	Если ИмяКоманды = "СтатусСогласовано" Тогда
		Точка = Перечисления.СтатусыЗаказовКлиентов.КОтгрузке;
	ИначеЕсли ИмяКоманды = "СтатусНеСогласовано" Тогда
		Точка = Перечисления.СтатусыЗаказовКлиентов.Новый;
	ИначеЕсли ИмяКоманды = "СтатусКОплате" Тогда
		Точка = Перечисления.СтатусыЗаказовКлиентов.Отгружен;
	ИначеЕсли ИмяКоманды = "СтатусОтменено" Тогда
		Точка = Перечисления.СтатусыЗаказовКлиентов.Отменен;
	Иначе
		Точка = Перечисления.СтатусыЗаказовКлиентов.Новый;
	КонецЕсли;
	
	Для каждого ТекЗаявка Из Заявки Цикл
		Об = ТекЗаявка.ПолучитьОбъект();
		Об.Статус = Точка;
		Если Об.Проведен Тогда
			Об.Записать(РежимЗаписиДокумента.Проведение);
		Иначе	
			Об.Записать();
		КонецЕсли;
	КонецЦикла; 
	
КонецПроцедуры

&НаКлиенте
Процедура ТолькоМоиПриИзменении(Элемент)
	Список.Параметры.УстановитьЗначениеПараметра("ТолькоМои", ТолькоМои);
	Список.Параметры.УстановитьЗначениеПараметра("ТолькоОткрытые", ТолькоОткрытые);
КонецПроцедуры

&НаКлиенте
Процедура ТолькоОткрытыеПриИзменении(Элемент)
	Список.Параметры.УстановитьЗначениеПараметра("ТолькоМои", ТолькоМои);
	Список.Параметры.УстановитьЗначениеПараметра("ТолькоОткрытые", ТолькоОткрытые);
КонецПроцедуры


&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Не Элементы.Список.РежимВыбора Тогда
		Если Поле.Имя = "Статус" И (Не ЗаблокироватьРеквизитыЗаказа Или РазрешитьСменуСтатусаЗаказа) Тогда
			СтандартнаяОбработка = Ложь;
			СписокЗначений = Новый СписокЗначений;
			СписокЗначений.ЗагрузитьЗначения(ПолучитьСписокСтатусовЗаказа());
			ТекЗнач = Неопределено;

			ПоказатьВыборИзСписка(Новый ОписаниеОповещения("СписокВыборЗавершение", ЭтаФорма), СписокЗначений, , СписокЗначений.НайтиПоЗначению(Элементы.Список.ТекущиеДанные.Статус));
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	ТекЗнач = ВыбранныйЭлемент;
	Если Не ТекЗнач = Неопределено Тогда
		ЗаписатьНовыйСтатусЗаказа(Элементы.Список.ТекущаяСтрока, ТекЗнач.Значение);
		Элементы.Список.Обновить();
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСписокСтатусовЗаказа()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	СтатусыЗаказовКлиентов.Ссылка
	|ИЗ
	|	Перечисление.СтатусыЗаказовКлиентов КАК СтатусыЗаказовКлиентов";
	
	Результат = Запрос.Выполнить();
	Возврат Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции // ()

&НаСервереБезКонтекста
Процедура ЗаписатьНовыйСтатусЗаказа(Документ, НовыйСтатусЗаказа)
	ТекБанкОб = Документ.ПолучитьОбъект();
	ТекБанкОб.Статус = НовыйСтатусЗаказа;
	Если ТекБанкОб.Проведен Тогда
		ТекБанкОб.Записать(РежимЗаписиДокумента.Проведение);
	Иначе	
		ТекБанкОб.Записать();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОповеститьРегистрОбработанных" Тогда
		Элементы.Список.Обновить();;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НеВМЛПриИзменении(Элемент)
	Список.Параметры.УстановитьЗначениеПараметра("НеВМЛ", НеВМЛ);
КонецПроцедуры

&НаСервере
Функция СправочникиСпособыДоставкиСобственнаяСлужбаДоставки()
	Возврат Справочники.СпособыДоставки.НайтиПоНаименованию("Собственная служба доставки");
КонецФункции