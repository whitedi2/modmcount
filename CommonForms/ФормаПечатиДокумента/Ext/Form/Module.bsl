﻿
&НаКлиенте
Процедура ТабДокПриАктивизацииОбласти(Элемент)
	ИтогоСумма = Формат(БюджетныйНаКлиенте.Просуммировать(Результат), "ЧДЦ=2");
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоЭлектроннойПочте(Команда)
	
	//lud
	//ОтображениеСостояния = Элементы.Результат.ОтображениеСостояния;
	//Если ОтображениеСостояния.Видимость = Истина
	//	И ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность Тогда
	//	ТекстВопроса = НСтр("ru = 'Отчет не сформирован. Сформировать?'");
	//	Обработчик = Новый ОписаниеОповещения("ОтправитьПоЭлектроннойПочтеПослеДиалогаСформировать", ЭтотОбъект);
	//	ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да);
	//Иначе
		ПоказатьДиалогОтправкиПоЭлектроннойПочте();
	//КонецЕсли;  
	
	
КонецПроцедуры   

&НаКлиенте
Процедура ПоказатьДиалогОтправкиПоЭлектроннойПочте()
	
	//ТабличныеДокументы = Новый СписокЗначений;
	//ТабличныеДокументы.Добавить(ЭтаФорма.Результат, Заголовок);
	//
	//ПараметрыФормы = Новый Структура;
	//ПараметрыФормы.Вставить("ТабличныеДокументы", ТабличныеДокументы);
	//ПараметрыФормы.Вставить("Тема", Заголовок);
	//ПараметрыФормы.Вставить("АдресEmail", АдресEmail);
	//ПараметрыФормы.Вставить("Предмет", Заявка);
	//ПараметрыФормы.Вставить("Заголовок", СтрЗаменить(
	//НСтр("ru = 'Отправка печатной формы документа ""%1"" по почте'"),
	//"%1",
	//Заголовок));
	//
	//ОтчетНаименованиеТекущегоВарианта = Заголовок;
	//
	//ТабличныеДокументы = Новый СписокЗначений;
	//ТабличныеДокументы.Добавить(ЭтаФорма.Результат, ОтчетНаименованиеТекущегоВарианта);
	//
	//ЗаголовокСохранения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Отправка печатной формы документа ""%1"" по почте'"), ОтчетНаименованиеТекущегоВарианта);
	//
	//ПараметрыОтправки = Новый Структура("Тема, Получатель, Предмет", ОтчетНаименованиеТекущегоВарианта, АдресEmail, Заявка);
	//
	//МодульРаботаСПочтовымиСообщениямиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСПочтовымиСообщениямиКлиент");
	//МодульРаботаСПочтовымиСообщениямиКлиент.ОтправитьТабличныеДокументы(ТабличныеДокументы, ЗаголовокСохранения, ПараметрыОтправки);
	
	
	Вложение = Новый Структура;
	Вложение.Вставить("АдресВоВременномХранилище", ПоместитьВоВременноеХранилище(Результат, УникальныйИдентификатор));
	Вложение.Вставить("Представление", ИмяДокумента); 
	
	СписокВложений = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Вложение);
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
		МодульРаботаСПочтовымиСообщениямиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСПочтовымиСообщениямиКлиент");
		ПараметрыОтправки = МодульРаботаСПочтовымиСообщениямиКлиент.ПараметрыОтправкиПисьма();   
		ПараметрыОтправки.Получатель = АдресEmail;  
		Организация = БюджетныйНаСервере.ВернутьРеквизит(Заявка,"Организация");
		ПараметрыОтправки.Тема = Строка(Заявка) + ?(ЗначениеЗаполнено(Организация), " (" + Строка(Организация) + ")", ""); 
		ПараметрыОтправки.Вложения = СписокВложений;
		МодульРаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(ПараметрыОтправки);
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры) Экспорт
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(Расшифровка) = Тип("Структура") Тогда
		Если Расшифровка.Свойство("Файл") Тогда
			СтруктураФайла = РаботаСGDrive.ПолучитьИмяФайлаНаСервере(Расшифровка.Файл);
			
			Если РаботаСGDrive.ЕстьПараметрыGDrive() И СтруктураФайла.ФайлСуществует Тогда
				БюджетныйНаКлиенте.ОткрытьВФормеHTML(СтруктураФайла);	
			Иначе	
				//ПоказатьЗначение(Неопределено, Расшифровка.Файл);
				ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(Расшифровка.Файл, Неопределено,
				УникальныйИдентификатор, Неопределено, "");
				РаботаСФайламиСлужебныйКлиент.ОткрытьФайлСОповещением(Неопределено, ДанныеФайла, УникальныйИдентификатор);
			КонецЕсли;
		ИначеЕсли Расшифровка.Свойство("ПечатьКомментариев") Тогда
			СтандартнаяОбработка = Ложь;
			ТабДок = Новый ТабличныйДокумент;
			Если Расшифровка.МассивОткрытыхИсторий = Неопределено Тогда
				Масс = Новый Массив;
			Иначе
				Масс = Расшифровка.МассивОткрытыхИсторий;	
			КонецЕсли;
			Если Расшифровка.ПечатьКомментариев Тогда
				Масс.Добавить(Расшифровка.РецензентКомментарий);
			Иначе
				Масс.Удалить(Масс.Найти(Расшифровка.РецензентКомментарий));
			КонецЕсли;
			ПечатьСКомментариями(ТабДок, Расшифровка.Ссылка, Расшифровка.РецензентКомментарий, Масс, Неопределено);
			ТабДок.ОтображатьСетку = Ложь;
			ТабДок.Защита = Ложь;
			ТабДок.ТолькоПросмотр = Истина;
			ТабДок.ОтображатьЗаголовки = Ложь;
			ЭтаФорма.Результат = ТабДок;
			
		ИначеЕсли Расшифровка.Свойство("ПечатьКомментариевАвтора") Тогда
			СтандартнаяОбработка = Ложь;
			ТабДок = Новый ТабличныйДокумент;
			Если Расшифровка.МассивОткрытыхИсторийАвтора = Неопределено Тогда
				МассивКомментариевАвтора = Новый Массив;
			Иначе
				МассивКомментариевАвтора = Расшифровка.МассивОткрытыхИсторийАвтора;	
			КонецЕсли;
			Если Расшифровка.ПечатьКомментариевАвтора Тогда
				МассивКомментариевАвтора.Добавить(Расшифровка.РецензентКомментарий);
			Иначе
				МассивКомментариевАвтора.Удалить(МассивКомментариевАвтора.Найти(Расшифровка.РецензентКомментарий));
			КонецЕсли;
			ПечатьСКомментариями(ТабДок, Расшифровка.Ссылка, , , МассивКомментариевАвтора);
			ТабДок.ОтображатьСетку = Ложь;
			ТабДок.Защита = Ложь;
			ТабДок.ТолькоПросмотр = Истина;
			ТабДок.ОтображатьЗаголовки = Ложь;
			ЭтаФорма.Результат = ТабДок;
			
		ИначеЕсли Расшифровка.Свойство("КарточкаКонтрагента") Тогда
			СтандартнаяОбработка = Ложь;
			
			ПользовательскиеНастройкиСКД = новый ПользовательскиеНастройкиКомпоновкиДанных;			
			ОтборСКД = ПользовательскиеНастройкиСКД.Элементы.Добавить(Тип("ОтборКомпоновкиДанных"));
			ОтборСКД.ИдентификаторПользовательскойНастройки = "Отбор";
			НовыйЭлементОтбора = ОтборСКД.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			НовыйЭлементОтбора.ЛевоеЗначение    = новый ПолеКомпоновкиДанных("Контрагенты");
			НовыйЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
			НовыйЭлементОтбора.ПравоеЗначение   = Расшифровка.Контрагент;
			НовыйЭлементОтбора.Использование    = Истина;
			НовыйЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;		
			ДопольнительныеСвойства = ПользовательскиеНастройкиСКД.ДополнительныеСвойства;
			ДопольнительныеСвойства.Вставить("НачалоПериода",           НачалоКвартала(ТекущаяДата()));
			ДопольнительныеСвойства.Вставить("КонецПериода",            КонецКвартала(ТекущаяДата()));
			ДопольнительныеСвойства.Вставить("Период",                  новый СтандартныйПериод(ДопольнительныеСвойства.НачалоПериода, ДопольнительныеСвойства.КонецПериода));
			ДопольнительныеСвойства.Вставить("ПоказательБУ",            Истина);
			ДопольнительныеСвойства.Вставить("ПоказательВалютнаяСумма", Ложь);
			ДопольнительныеСвойства.Вставить("ПоказательКоличество",    Ложь);
			ДопольнительныеСвойства.Вставить("ПоказательКрахмал",       Ложь);
			ДопольнительныеСвойства.Вставить("ПоказательКурс",          Ложь);
			ДопольнительныеСвойства.Вставить("ПоказательЦена",          Ложь);
			ДопольнительныеСвойства.Вставить("РежимРасшифровки",        Ложь);
			ДопольнительныеСвойства.Вставить("Счет",                    Расшифровка.Счет);
			
			ЗаполняемыеНастройки = Новый Структура("Показатели, Группировка, Отбор", Ложь, Истина, Ложь);
			
			ПараметрыФормы = Новый Структура("ВидРасшифровки, ПользовательскиеНастройки, СформироватьПриОткрытии, ИДРасшифровки, ЗаполняемыеНастройки",
			2, ПользовательскиеНастройкиСКД, Истина, "сабКарточкаСчета", ЗаполняемыеНастройки);
			ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
			
			Форма = ПолучитьФорму("Отчет.сабКарточкаСчета.Форма.ФормаОтчета", ПараметрыФормы);
			Форма.Элементы.ПанельНастроек.Пометка = Ложь;
			//Форма.Открыть();
			//Форма.СформироватьОтчет(0);
			Форма.СформироватьОтчетСервер();
			Форма.Открыть();
		ИначеЕсли Расшифровка.Свойство("Статья") Тогда
			СтандартнаяОбработка = Ложь;
			ТекФорма = ПолучитьФорму("Справочник.СтатьиДвиженияДенежныхСредств.Форма.ФормаВыбораЗаявкаПечать", Новый Структура("ТекущаяСтрока", Расшифровка.Статья) , Элемент);
			ТекФорма.СтатьяДДС = Расшифровка.Статья;
			СтатьяСсылка = ТекФорма.ОткрытьМодально();
			Если НЕ СтатьяСсылка = Неопределено Тогда
				ИзменитьСтатью(СтатьяСсылка, Расшифровка.Ссылка, Расшифровка.НомерСтроки);		
			КонецЕсли;
		ИначеЕсли Расшифровка.Свойство("Подразделение") Тогда
			СтандартнаяОбработка = Ложь;
			аа = ПолучитьФорму("Справочник.СтруктураПредприятия.ФормаВыбора", Новый Структура("ТекущаяСтрока, Владелец", Расшифровка.Подразделение, Расшифровка.Предприятие));
			НовыйОтбор = аа.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Владелец");
			НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			НовыйОтбор.ПравоеЗначение = Расшифровка.Предприятие;
			НовоеПодразделение = аа.ОткрытьМодально();
			Если НЕ НовоеПодразделение = Неопределено Тогда
				ИзменитьПодразделение(НовоеПодразделение, Расшифровка.Ссылка, Расшифровка.НомерСтроки);		
			КонецЕсли;
			
		ИначеЕсли Расшифровка.Свойство("ОтменаОплаты") Тогда
			ВозможностьОтменыОплаты = ПроверкаВозможностиОтменыОплаты(Расшифровка);
			
			Если НЕ ВозможностьОтменыОплаты Тогда
				Предупреждение("Невозможно отменить/вернуть оплату, т.к. вы не являетесь текущим исполнителем по заявке.");
				Возврат;		
			КонецЕсли;
			
			Комментарии = "";
			
			Если Расшифровка.ОтменаОплаты Тогда
				
				Если Вопрос("Вы уверены, что хотите вернуть данную оплату?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да  Тогда
					ОтменитьОплату(Расшифровка, Ложь, "");	
				КонецЕсли;
				
			Иначе
				
				Если Вопрос("Вы уверены, что хотите отменить данную оплату?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да  Тогда
					ВвестиСтроку(Комментарии, "Ваши комментарии");
					ОтменитьОплату(Расшифровка, Истина, Комментарии);	
				КонецЕсли;
				
			КонецЕсли;
			
		ИначеЕсли Расшифровка.Свойство("ЗаявкаНаОплатуПечать") И Расшифровка.Свойство("СтатьяДДС") И РедактированиеСтатьиДДС Тогда
			СтандартнаяОбработка = Ложь;
			ТекФорма = ПолучитьФорму("Справочник.СтатьиДвиженияДенежныхСредств.Форма.ФормаВыбораЗаявкаПечать", , Элемент);
			//ТекФорма.Заявка = Расшифровка.Регистратор;
			//ТекФорма.НомерСтроки = Расшифровка.НомерСтроки;
			//ТекФорма.ТабДок = ТабДок;
			ТекФорма.СтатьяДДС = Расшифровка.СтатьяДДС;
			СтатьяСсылка = ТекФорма.ОткрытьМодально();
			
			Если НЕ СтатьяСсылка = Неопределено Тогда
				ИзменитьСтатью(СтатьяСсылка, Расшифровка.Регистратор, Расшифровка.НомерСтроки);		
			КонецЕсли;
			
		ИначеЕсли Расшифровка.Свойство("Приложение") Тогда // новый алгоритм открытия приложений
			
			Если ЗначениеЗаполнено(Расшифровка.ЗаявкаНаФинансирование) Тогда
				ТекФорма = ПолучитьФорму("РегистрСведений.ПрикрепленныеОбъекты.ФормаСписка", Новый Структура("СписокФайлов, ВладелецБезОтбора, ЗаявкаНаФинансирование", Расшифровка.Приложение, Расшифровка.ВладелецБезОтбора, Расшифровка.ЗаявкаНаФинансирование), ЭтаФорма);		
				ТекФорма.Открыть();
			Иначе
				
				Если Расшифровка.Приложение.Количество() Тогда
					ПоказатьЗначение(Неопределено, Расшифровка.Приложение[0]);
				КонецЕсли;
				
			КонецЕсли;
			
		ИначеЕсли Расшифровка.Свойство("ЗаявкаНаОплатуПечать") И Расшифровка.Свойство("ИнвПроект") Тогда
			ПоказатьЗначение(Неопределено, Расшифровка.ИнвПроект);
			
		ИначеЕсли Расшифровка.Свойство("ЗаявкаНаОплатуПроверкаСоответствия") И Расшифровка.Свойство("Регистратор") Тогда //для проверки соотв заявок на опл
			СтандартнаяОбработка = Ложь;
			ТекФорма = ПолучитьФорму("Справочник.СтатьиДДС.Форма.ФормаВыбораЗаявка", , Элемент);
			ТекФорма.Заявка = Расшифровка.Регистратор;
			ТекФорма.НомерСтроки = Расшифровка.НомерСтроки;
			ТекФорма.ТабДок = ТабДок;
			ТекФорма.СтатьяДДС = Расшифровка.СтатьяДДС;
			ТекФорма.Открыть();
		ИначеЕсли  Расшифровка.Свойство("ЗаявкаНаОплатуПроверкаСоответствия") И Расшифровка.Свойство("Признак") Тогда
			Тд = Новый ТабличныйДокумент;
			Если Расшифровка.Признак = "План" Тогда
				ПараметрыРасшифровкиПлана(Расшифровка, Тд);
			Иначе
				ПараметрыРасшифровкиФакта(Расшифровка, Тд);
			КонецЕсли;
			Тд.ОтображатьСетку = Ложь;
			Тд.Защита = Ложь;
			Тд.ТолькоПросмотр = Истина;
			Тд.ОтображатьЗаголовки = Истина;
			Тд.ОтображатьГруппировки = Истина;
			Тд.АвтоМасштаб = Истина;
			ФормаПечати = ПолучитьФорму("ОбщаяФорма.ФормаПечатиДокумента");
			ФормаПечати.Автозаголовок = Ложь;
			ФормаПечати.Заголовок = "Форма документа:";
			ФормаПечати.Результат = Тд;
			ФормаПечати.Открыть();
		ИначеЕсли  Расшифровка.Свойство("РазвернутьСвернутьГруппу") И Расшифровка.Свойство("ЗаявкаНаОплатуПечать") Тогда
			Развернут0Уровень = 1 - Развернут0Уровень;
			
			Если ЗначениеЗаполнено(ИмяКоманды) Тогда
				БюджетныйНаКлиенте.УниверсальноеВыполнениеКоманды(Расшифровка.Документ, ИмяКоманды, ЭтаФорма, Новый Структура("ДопПараметры", Новый Структура("ПоказыватьГруппуВопросов", Развернут0Уровень)));
			КонецЕсли;
			
		ИначеЕсли Расшифровка.Свойство("ИзменитьСчетВзаиморасчетов") Тогда
			
			Если ЕстьВозможностьМенятьСчетВзаиморасчетов() Тогда
				ТекЗнач = ВыбратьИзСписка(Расшифровка.СчетаВзаиморассчетов, , Расшифровка.СчетаВзаиморассчетов.НайтиПоЗначению(Расшифровка.СчетВзаиморасчетов));
				
				Если Не ТекЗнач = Неопределено Тогда
					
					Если ЗначениеЗаполнено(Расшифровка.Договор) Тогда
						УстановитьНовыйСчетВДоговоре(Расшифровка.Договор, ТекЗнач.Значение, Расшифровка.Заявка)
					Иначе
						УстановитьНовыйСчетВСтрокеТЧ(Расшифровка.НомерСтрокиТЧ, ТекЗнач.Значение, Расшифровка.Заявка)
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Расшифровка) = Тип("СправочникСсылка.Контрагенты") Тогда
		СтандартнаяОбработка = Ложь;
		СписокМеню = Новый СписокЗначений;
		СписокМеню.Добавить("Карточка контрагента");
		СписокМеню.Добавить("Форма элемента");
		ТекЗнач = ВыбратьИзМеню(СписокМеню);
		Если Не ТекЗнач = Неопределено Тогда
			Если ТекЗнач.Значение = "Карточка контрагента" Тогда
				БюджетныйНаКлиенте.УниверсальноеВыполнениеКоманды(Расшифровка, "Справочник.Контрагенты.Команда.КарточкаКонтрагента");
			Иначе
				ПоказатьЗначение(Неопределено, Расшифровка);
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли сабОбщегоНазначения.ЭтаСсылкаСправочник(Расшифровка) = Истина Или сабОбщегоНазначения.ЭтаСсылкаДокумент(Расшифровка) = Истина Тогда
		ПоказатьЗначение(Неопределено, Расшифровка);
	Иначе
		
		Если ТипЗнч(Расшифровка) = Тип("ИдентификаторРасшифровкиКомпоновкиДанных") Тогда
			ОбъектРасшифровки = ВернутьДанныеРасшифровки(Расшифровка);
			Если сабОбщегоНазначения.ЭтаСсылкаСправочник(ОбъектРасшифровки) = Истина Или сабОбщегоНазначения.ЭтаСсылкаДокумент(ОбъектРасшифровки) = Истина Тогда
				ПоказатьЗначение(, ОбъектРасшифровки);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВернутьДанныеРасшифровки(Расшифровка)
	ДанныеРасшифровкиСКД = ПолучитьИзВременногоХранилища(ДанныеРасшифровки);
	ЭлементРасшифровки = ДанныеРасшифровкиСКД.Элементы[Расшифровка];
	Если ТипЗнч(ЭлементРасшифровки) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") Тогда
		Для каждого Поле Из ЭлементРасшифровки.ПолучитьПоля() Цикл
			Возврат Поле.Значение;
		КонецЦикла;
	КонецЕсли;
КонецФункции // ()


&НаКлиенте
Процедура ОбработатьРасшифровку(ВыбранноеДействие,ВыбранноеЗначение,Параметр3) Экспорт

	// поле выбора действия, обрабаытваем нужные нам манипуляции
	// в нашем случае можно этого не делать, так как у нас доступно только действие "ОткрытьЗначение"
	Если ВыбранноеДействие <> ДействиеОбработкиРасшифровкиКомпоновкиДанных.Нет Тогда
		Если ВыбранноеДействие = ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение Тогда
			// в режиме запрета модальности используем "ПоказатьЗначение"
			ПоказатьЗначение(,ВыбранноеЗначение);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РезультатВыбор(Элемент, Область, СтандартнаяОбработка)
	Если Область <>	Неопределено И ТипЗнч(Область) = Тип("ОбластьЯчеекТабличногоДокумента") Тогда
		Если Лев(Область.Текст, 19) = "Внутренний документ" Тогда
			Ссылка = ПолучитьСсылкуНеСервере(Сред(Область.Текст, 21, 11), Дата(СокрЛП(Сред(Область.Текст, 36, 10))+" 00:00:00"));
			Форма = ПолучитьФорму("Документ" + Строка(ИмяДокумента) + ".Форма.ФормаДокумента",Новый Структура("Ключ", Ссылка)); 
			Форма.Открыть();
		//ИначеЕсли Лев(Область.Текст, 23) = "Реестр платежей" Тогда
		//	ИмяДокумента = "Д_ЗаявкаНаОплату";
		//	Ссылка = ПолучитьСсылкуНеСервере(Сред(Область.Текст, 25, 11), Дата(СокрЛП(Сред(Область.Текст, 40, 10))+" 00:00:00"));
		//	Форма = ПолучитьФорму("Документ." + Строка(ИмяДокумента) + ".Форма.ФормаДокумента",Новый Структура("Ключ", Ссылка)); 
		//	Форма.Открыть();
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСсылкуНеСервере(Номер, Дата)
	
	Возврат Документы[ИмяДокумента].НайтиПоНомеру(Номер, Дата); 
	
КонецФункции

&НаСервере
Процедура ПечатьСКомментариями(ТабДок, ПараметрКоманды, РецензентКомментарий, МассивОткрытыхИсторий, МассивОткрытыхИсторийАвтора)
	
	Документы[ИмяДокумента].Печать(ТабДок, ПараметрКоманды, РецензентКомментарий, МассивОткрытыхИсторий, МассивОткрытыхИсторийАвтора);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Ссылка") Тогда
		ИмяДокумента = Параметры.Ссылка[0].Метаданные().Имя;
	Иначе
		ИмяДокумента = "Д_СлужебнаяЗаписка";
	КонецЕсли;
	
	Если Параметры.Свойство("ИмяКоманды") Тогда
		ИмяКоманды = Параметры.ИмяКоманды;	
	КонецЕсли;
	
	Если Параметры.Свойство("АдресEmail") Тогда
		АдресEmail = Параметры.АдресEmail;
	КонецЕсли;
	
	Если Параметры.Свойство("Заявка") Тогда
		Заявка = Параметры.Заявка;
	КонецЕсли;   
	
КонецПроцедуры


&НаСервере
Процедура ИзменитьСтатью(СтатьяСсылка, Заявка, НомерСтроки)
	ЗаявкаОбъект = Заявка.ПолучитьОбъект();
	ТекСтрока = ЗаявкаОбъект.Затраты[НомерСтроки - 1];
	ТекСтрока.Статья = СтатьяСсылка;
	Если ЗаявкаОбъект.Проведен Тогда
		ЗаявкаОбъект.Записать(РежимЗаписиДокумента.Проведение);
	Иначе
		ЗаявкаОбъект.Записать();
	КонецЕсли;
	МассивЗаявок = Новый Массив;
	МассивЗаявок.Добавить(Заявка);
	Документы[ИмяДокумента].Печать(Результат, МассивЗаявок);
КонецПроцедуры

&НаСервере
Процедура ИзменитьПодразделение(Подразделение, Заявка, НомерСтроки)
	ЗаявкаОбъект = Заявка.ПолучитьОбъект();
	ТекСтрока = ЗаявкаОбъект.Затраты[НомерСтроки - 1];
	ТекСтрока.Подразделение = Подразделение;
	Если ЗаявкаОбъект.Проведен Тогда
		ЗаявкаОбъект.Записать(РежимЗаписиДокумента.Проведение);
	Иначе
		ЗаявкаОбъект.Записать();
	КонецЕсли;
	МассивЗаявок = Новый Массив;
	МассивЗаявок.Добавить(Заявка);
	Документы[ИмяДокумента].Печать(Результат, МассивЗаявок);
КонецПроцедуры

&НаСервере
Процедура ОтменитьОплату(Расшифровка, ОтменаОплаты, Комментарии)
	
	//у фиников нет прав для интерактивной отмены оплаты, кроме фиников, присутствующих в маршруте
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Согласование1ДопСогласование.Пользователь
	|ИЗ
	|	Справочник.Согласование1.ДопСогласование КАК Согласование1ДопСогласование
	|ГДЕ
	|	Согласование1ДопСогласование.Ссылка.Заявка = &Заявка
	|	И Согласование1ДопСогласование.СубъектСогласования В(&СубъектСогласования)";
	
	Запрос.УстановитьПараметр("Заявка", Расшифровка.Заявка);
	Запрос.УстановитьПараметр("СубъектСогласования", БПСервер.ПолучитьМассивПользователей());
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Если РольДоступна("Финансист") И НЕ РольДоступна("ОФК") И НЕ Выборка.Количество() Тогда
		Сообщить("Недостаточно прав.");
		Возврат;	
	КонецЕсли;
	
	ЗаявкаОбъект = Расшифровка.Заявка.ПолучитьОбъект();
	
	
	ТекСтрока = ЗаявкаОбъект.ЗаявкаБезнал[Расшифровка.НомерСтроки - 1];
	
	//у стороннего рецензента нет прав для возврата отмены оплаты
	//Если ТекСтрока.ОтменаОплаты = Истина И НЕ ПустаяСтрока(ТекСтрока.Рецензент) И НЕ ПараметрыСеанса.ТекущийПользователь = ТекСтрока.Рецензент И НЕ ПараметрыСеанса.ТекущийПользователь = Справочники.Пользователи.РуководительДКФ Тогда
	//	Сообщить("Невозможно вернуть оплату, т.к. не Вы ее отменяли.");
	//	Возврат;	
	//КонецЕсли;
	
	// нельзя отменить уже отмененное
	Если ТекСтрока.ОтменаОплаты = Истина Тогда
		Сообщить("Невозможно вернуть отмененную оплату.");
		Возврат;	
	КонецЕсли;
	
	ТекСтрока.ОтменаОплаты = ОтменаОплаты;
	ТекСтрока.Рецензент = ?(ОтменаОплаты, ПараметрыСеанса.ТекущийПользователь, Справочники.Пользователи.ПустаяСсылка());
	ТекСтрока.Комментарии = Строка(Комментарии);
	
	Если ОтменаОплаты И ЗначениеЗаполнено(ТекСтрока.ЗаявкаНаФинансирование) Тогда
		СтрокиПоЗаявкеНаФинансирование = ЗаявкаОбъект.ЗаявкаБезнал.НайтиСтроки(Новый Структура("ЗаявкаНаФинансирование", ТекСтрока.ЗаявкаНаФинансирование));
		
		Для Каждого ТекСтрокаЗФ Из СтрокиПоЗаявкеНаФинансирование Цикл
			
			Если ТекСтрокаЗФ = ТекСтрока Тогда
				ТекСтрокаЗФ.ЗаявкаНаФинансирование = Документы.Д_ЗаявкаНаФинансирование.ПустаяСсылка();
				Продолжить;
			КонецЕсли;
			
			ТекСтрокаЗФ.ОтменаОплаты = ОтменаОплаты;
			ТекСтрокаЗФ.ЗаявкаНаФинансирование = Документы.Д_ЗаявкаНаФинансирование.ПустаяСсылка();
			ТекСтрокаЗФ.Рецензент = ПараметрыСеанса.ТекущийПользователь;
			ТекСтрокаЗФ.Комментарии = Строка(Комментарии);
		КонецЦикла;
		
	КонецЕсли;
	
	ЗаявкаОбъект.Записать(РежимЗаписиДокумента.Проведение);
	Документы.Д_ЗаявкаНаОплату.Печать(Результат, Расшифровка.Заявка);
	//Документы.Д_ЗаявкаНаОплату.ПустаяСсылка().ЗаявкаБезнал.Получить(1).ОтменаОплаты
КонецПроцедуры

&НаСервере
Функция ПроверкаВозможностиОтменыОплаты(Расшифровка)
	
	ТекБП = БПСервер.НайтиТекущийБПСервер(Расшифровка.Заявка);
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Задача.Ссылка,
	|	Задача.Исполнитель
	|ИЗ
	|	Справочник.Задача КАК Задача
	|ГДЕ
	|	Задача.БизнесПроцесс = &БизнесПроцесс
	|	И Задача.Выполнена = ЛОЖЬ
	|	И Задача.ПометкаУдаления = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("БизнесПроцесс", ТекБп);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если НЕ БПСервер.ПолучитьМассивПользователей().Найти(Выборка.Исполнитель) = Неопределено Тогда
			Возврат Истина;		
		КонецЕсли;
	КонецЦикла;
	Возврат Ложь;
	
КонецФункции

#Область РасшифровкаЗаявкаНаОплату_ПроверкаСоотв

&НаСервере
Процедура ПараметрыРасшифровкиФакта(Расшифровка, РезультатОтчет)

	
	СхемаКомпоновкиДанных = Документы.Д_ЗаявкаНаОплату.ПолучитьМакет("РасшифровкаФакта");
	
	//Из схемы возьмем настройки по умолчанию
    Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	Настройки.ПараметрыДанных.Элементы[0].Значение.ДатаНачала = Расшифровка.Дата1;
	Настройки.ПараметрыДанных.Элементы[0].Значение.ДатаОкончания = Расшифровка.Дата2;
	Настройки.ПараметрыДанных.Элементы[1].Значение = Расшифровка.ЦФО;
	Настройки.ПараметрыДанных.Элементы[2].Значение = Расшифровка.ПодразделениеЦФО;
	Настройки.ПараметрыДанных.Элементы[3].Значение = Расшифровка.СтатьяДДС;
	Настройки.ПараметрыДанных.Элементы[4].Значение = Расшифровка.ИнвПроект;
	

	//Помещаем в переменную данные о расшифровке данных
	//ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	
	//Формируем макет, с помощью компоновщика макета
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;

    //Передаем в макет компоновки схему, настройки и данные расшифровки
    МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных,
    Настройки,);

    //Выполним компоновку с помощью процессора компоновки
    ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
    ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки,,
    ,Истина);
	
	//Очищаем поле табличного документа
	РезультатОтчет.Очистить();
	
	//Выводим результат в табличный документ
    ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
    ПроцессорВывода.УстановитьДокумент(РезультатОтчет);

    ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	
	
	
	
	
КонецПроцедуры

&НаСервере
Процедура ПараметрыРасшифровкиПлана(Расшифровка, РезультатОтчет)
	
	//ПолныйПросмотрЛимитов = сабОбщегоНазначения.ПолучитьЗначениеСвойства(ПараметрыСеанса.ТекущийПользователь, ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.ПривилегированныйПросмотрЛимитов);
	ПолныйПросмотрЛимитов = Истина;

	Если ПолныйПросмотрЛимитов = Истина Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;	
	
	СхемаКомпоновкиДанных = Документы.Д_ЗаявкаНаОплату.ПолучитьМакет("РасшифровкаПлана");
	
	//Из схемы возьмем настройки по умолчанию
    Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	Настройки.ПараметрыДанных.Элементы[0].Значение.ДатаНачала = Расшифровка.Дата1;
	Настройки.ПараметрыДанных.Элементы[0].Значение.ДатаОкончания = Расшифровка.Дата2;
	Настройки.ПараметрыДанных.Элементы[1].Значение = Расшифровка.СтатьяДДС;
	Настройки.ПараметрыДанных.Элементы[2].Значение = Расшифровка.ЦФО;
	Настройки.ПараметрыДанных.Элементы[3].Значение = Расшифровка.ПодразделениеЦФО;
	Настройки.ПараметрыДанных.Элементы[4].Значение = Расшифровка.ИнвПроект;
	Настройки.ПараметрыДанных.Элементы[5].Значение = (Расшифровка.ПодразделениеЦФО = "Основное");
	
	//Помещаем в переменную данные о расшифровке данных
	//ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	
	//Формируем макет, с помощью компоновщика макета
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;

    //Передаем в макет компоновки схему, настройки и данные расшифровки
    МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных,
    Настройки,);

    //Выполним компоновку с помощью процессора компоновки
    ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
    ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки,,
    ,Истина);
	
	//Очищаем поле табличного документа
	РезультатОтчет.Очистить();
	
	//Выводим результат в табличный документ
    ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
    ПроцессорВывода.УстановитьДокумент(РезультатОтчет);

    ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);	
	
КонецПроцедуры

#КонецОбласти 

Процедура УстановитьНовыйСчетВДоговоре(ТекДоговор, ТекСчет, Заявка)
	
	Успешно = Ложь;
	
	Попытка
		ДоговорОбъект = ТекДоговор.ПолучитьОбъект();
		ДоговорОбъект.СчетВзаиморасчетов = ТекСчет;
		ДоговорОбъект.Записать();
		Успешно = Истина;
	Исключение
		Сообщить("Не удалось установить счет взаиморасчетов. Обратитесь к администратору");
	КонецПопытки;
	
	Если Успешно Тогда
		ЗаявкаОбъект = Заявка.ПолучитьОбъект();
		МассивЗаявок = Новый Массив;
		МассивЗаявок.Добавить(Заявка);
		Документы[ИмяДокумента].Печать(Результат, МассивЗаявок);
	КонецЕсли;
	
КонецПроцедуры	

Процедура УстановитьНовыйСчетВСтрокеТЧ(НомерСтр, ТекСчет, Заявка)
	
	Успешно = Ложь;
	
	Попытка
		ЗаявкаОбъект = Заявка.ПолучитьОбъект();
		ТекСтрокаТЧ = ЗаявкаОбъект.ЗаявкаБезнал.Получить(НомерСтр - 1);
		ТекСтрокаТЧ.СчетВзаиморасчетов = ТекСчет;
		ЗаявкаОбъект.Записать();
		Успешно = Истина;
	Исключение
		Сообщить("Не удалось установить счет взаиморасчетов. Обратитесь к администратору");
	КонецПопытки;
	
	Если Успешно Тогда
		МассивЗаявок = Новый Массив;
		МассивЗаявок.Добавить(Заявка);
		Документы[ИмяДокумента].Печать(Результат, МассивЗаявок);
	КонецЕсли;
	
КонецПроцедуры

Функция ЕстьВозможностьМенятьСчетВзаиморасчетов()

	Возврат рольдоступна("сабУчетчик");
	
КонецФункции	